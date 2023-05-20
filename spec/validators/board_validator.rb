require 'rails_helper'

class Validatable
  include ActiveModel::Validations

  cattr_accessor :width, default: 10
  cattr_accessor :height, default: 10
  cattr_accessor :mines, default: 10

  validates_with BoardValidator
end

RSpec.describe BoardValidator, focus: true do
  subject { Validatable.new() }

  context 'valid board' do
    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'with invalid width' do
    it 'is null' do
      subject.width = nil
      expect(subject).to be_invalid
    end
    it 'is 0' do
      subject.width = 0
      expect(subject).to be_invalid
    end
    it 'is > MAX' do
      subject.width = BoardValidator::MAX_HEIGHT + 1
      expect(subject).to be_invalid
    end
  end

  context 'with invalid height' do
    it 'is null' do
      subject.height = nil
      expect(subject).to be_invalid
    end
    it 'is 0' do
      subject.height = 0
      expect(subject).to be_invalid
    end
    it 'is >1000' do
      subject.height = BoardValidator::MAX_HEIGHT + 1
      expect(subject).to be_invalid
    end
  end

  context 'with invalid dimensions' do
    it "is invalid" do
      subject.mines = 1
      subject.width = 1
      subject.height = 1
      expect(subject).to be_invalid
    end
  end

  context 'with invalid mines' do
    it 'is 0' do
      subject.mines = 0
      expect(subject).to be_invalid
    end
    it 'is full' do
      subject.width = 10
      subject.height = 10
      subject.mines = 100
      expect(subject).to be_invalid
    end
  end
end
