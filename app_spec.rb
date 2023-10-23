require "./app"
require "whoop"

Whoop.setup do |config|
  config.logger = nil
  config.level = :debug
end

RSpec.describe App do
  describe ".predict_sentiment" do
    it "returns valid results" do
      results = App.predict_sentiment([
        "This is amazing!",
        "I'm not sure if this is the right approach.",
        "I am trying to think of good things to say, but I can't."
      ])

      whoop(".predict_sentiment") { results }

      expect(results).to be_a(Array)
      expect(results[0][:label]).to eq("positive")
      expect(results[1][:label]).to eq("negative")
      expect(results[2][:label]).to eq("negative")
    end
  end

  describe ".question_answering" do
    it "returns valid results" do
      results = App.question_answering(
        question: "Who invented Ruby?",
        context: "Ruby is a programming language created by Matz"
      )

      whoop(".question_answering") { results }
      expect(results).to be_a(Hash)
      expect(results[:answer]).to eq("Matz")
    end
  end

  describe ".named_entity_recognition" do
    it "returns valid results" do
      results = App.named_entity_recognition("Ruby is a programming language created by Matz")

      whoop(".named_entity_recognition") { results }

      expect(results).to be_a(Array)

      expect(results[0][:text]).to eq("Ruby")
      expect(results[0][:tag]).to be_nil
      expect(results[0][:start]).to eq(0)
      expect(results[0][:end]).to eq(4)

      expect(results[1][:text]).to eq("Matz")
      expect(results[1][:tag]).to eq("person")
      expect(results[1][:start]).to eq(42)
      expect(results[1][:end]).to eq(46)
    end
  end

  describe ".text_generation" do
    xit "returns valid results" do
      results = App.text_generation("Ruby is a programming language created by Matz", max_length: 50)

      whoop(".text_generation") { results }

      expect(results).to be_a(String)
      expect(results).to include("Ruby is a programming language created by Matz")
    end
  end

  describe ".feature_extraction" do
    it "returns valid results" do
      results = App.feature_extraction("Ruby is a programming language created by Matz")

      whoop(".feature_extraction") { results }

      expect(results).to be_a(Array)
      expect(results.length).to eq(11)
      expect(results[0][0]).to be_a(Float)
      expect(results[0].length).to eq(768)
      expect(results[0][0]).to be > 0.0
    end
  end

  describe ".fill_mask" do
    it "returns valid results" do
      results = App.fill_mask("Ruby is a programming language created by <mask>")

      whoop(".fill_mask") { results }

      expect(results).to be_a(Array)
      expect(results.length).to eq(5)
      expect(results[0][:token_str]).to eq("Microsoft")
      expect(results[0][:score]).to be > 0.0
    end
  end
end
