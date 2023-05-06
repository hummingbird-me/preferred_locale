# frozen_string_literal: true

RSpec.describe PreferredLocale do
  subject { described_class.new(available: available) }

  describe '.acceptable_locales' do
    context 'with only ja-JP available' do
      subject { described_class.new(available: ['ja-JP']) }

      it 'with nothing preferred, returns an empty array' do
        expect(subject.acceptable_for(locales: [])).to eq([])
      end

      it 'with only en-US preferred, returns an empty array' do
        expect(subject.acceptable_for(locales: ['en-US'])).to eq([])
      end

      it 'with ja-JP preferred, returns an array with ja-JP' do
        expect(subject.acceptable_for(locales: ['ja-JP'])).to eq(['ja-JP'])
      end

      it 'with ja-jp (lowercase) preferred, returns an array with ja-JP' do
        expect(subject.acceptable_for(locales: ['ja-jp'])).to eq(['ja-JP'])
      end

      it 'with ja preferred, returns an array with ja-JP' do
        expect(subject.acceptable_for(locales: ['ja'])).to eq(['ja-JP'])
      end
    end

    context 'with ja-JP and en-US available' do
      subject { described_class.new(available: %w[ja-JP en-US]) }

      it 'with only en-US preferred, returns an array with en-US' do
        expect(subject.acceptable_for(locales: ['en-US'])).to eq(['en-US'])
      end

      it 'with only en preferred, returns an array with en-US' do
        expect(subject.acceptable_for(locales: ['en'])).to eq(['en-US'])
      end

      it 'with en, ja-JP preferred, returns an array with en-US, ja-JP' do
        expect(subject.acceptable_for(locales: %w[en ja-JP])).to eq(%w[en-US ja-JP])
      end
    end

    context 'with ja and en available' do
      subject { described_class.new(available: %w[ja en]) }

      it 'with only en-US preferred, returns an array with en-US' do
        expect(subject.acceptable_for(locales: ['en-US'])).to eq(['en'])
      end

      it 'with only en preferred, returns an array with en-US' do
        expect(subject.acceptable_for(locales: ['en'])).to eq(['en'])
      end
    end

    context 'with pt-BR and pt-PT available' do
      subject { described_class.new(available: %w[pt-BR pt-PT]) }

      it 'with only pt preferred, returns an array with pt-BR' do
        expect(subject.acceptable_for(locales: ['pt'])).to eq(['pt-BR'])
      end
    end

    context 'with pt-BR, pt, and en available' do
      subject { described_class.new(available: %w[pt-BR pt en]) }

      # Verify that explicit languages aren't overriden by implicit ones
      it 'with pt-BR > en > pt preferred, returns an array with pt-BR, en, pt' do
        expect(subject.acceptable_for(locales: %w[pt-BR en pt])).to eq(%w[pt-BR en pt])
      end
    end
  end
end
