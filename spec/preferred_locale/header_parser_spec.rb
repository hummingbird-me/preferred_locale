# frozen_string_literal: true

require 'preferred_locale/header_parser'

RSpec.describe PreferredLocale::HeaderParser do
  describe '#raw_locales' do
    context 'with a wildcard' do
      subject { described_class.new('*;q=1.0') }

      it 'returns an array with the wildcard' do
        expect(subject.raw_locales).to eq(['*'])
      end
    end

    context 'with a wildly invalid value' do
      subject { described_class.new('🦊') }

      it 'still returns a reasonable parse' do
        expect(subject.raw_locales).to eq(['🦊'])
      end
    end

    context 'with spaces between locales' do
      subject { described_class.new('en-US;q=1.0, ja-JP;q=0.5') }

      it 'returns an array without the spaces' do
        expect(subject.raw_locales).to eq(%w[en-US ja-JP])
      end
    end

    context 'with a single locale' do
      subject { described_class.new('en-US;q=1.0') }

      it 'returns an array with the locale' do
        expect(subject.raw_locales).to eq(['en-US'])
      end
    end

    context 'with multiple locales in order of decreasing q value' do
      subject { described_class.new('en-US;q=1.0,ja-JP;q=0.5') }

      it 'returns an array with them in decreasing q value' do
        expect(subject.raw_locales).to eq(%w[en-US ja-JP])
      end
    end

    context 'with multiple locales in order of increasing q value' do
      subject { described_class.new('ja-JP;q=0.5,en-US;q=1.0') }

      it 'returns an array with them in decreasing q value' do
        expect(subject.raw_locales).to eq(%w[en-US ja-JP])
      end
    end
  end

  describe '#preferred_locales' do
    context 'with a wildcard' do
      subject { described_class.new('en-US;q=1.0,*;q=0.5') }

      it 'returns an array without the wildcard' do
        expect(subject.preferred_locales).not_to include('*')
      end

      it 'returns any other locales which were valid' do
        expect(subject.preferred_locales).to eq(%w[en-US])
      end
    end

    context 'with a wildly invalid value' do
      subject { described_class.new('🦊,en-US') }

      it 'returns an array without the invalid value' do
        expect(subject.preferred_locales).not_to include(['🦊'])
      end

      it 'returns any other locales which were valid' do
        expect(subject.preferred_locales).to eq(%w[en-US])
      end
    end

    context 'with an extended locale tag' do
      subject { described_class.new('en-US;q=1.0,en-US-POSIX;q=0.5') }

      it 'returns an array with the extended locale tag' do
        expect(subject.preferred_locales).to eq(%w[en-US en-US-POSIX])
      end
    end
  end
end
