require "rails_helper"

RSpec.describe Card, type: :models do
  subject {
    described_class.new(word:"test", 
      translation: "тест", 
      example: "How to Test Rails Models with RSpec")
   }

  it "is valid with valid attributes" do
      expect(subject).to be_valid
  end

  it "is not valid without a word" do
    subject.word = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a translation" do
    subject.translation = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without an example" do
    subject.example = nil
    expect(subject).to_not be_valid
  end
end
