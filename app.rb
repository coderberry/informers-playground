require "bundler/setup"

require "colorize"
require "informers"
require "whoop"

Whoop.setup do |config|
  config.logger = nil
  config.level = :debug
end

def predict_sentiment(values:)
  model = Informers::SentimentAnalysis.new("./models/sentiment-analysis.onnx")
  model.predict(values)
end

def question_answering(question:, context:)
  model = Informers::QuestionAnswering.new("./models/question-answering.onnx")
  model.predict(question: question, context: context)
end

def named_entity_recognition(phrase:)
  model = Informers::NER.new("./models/ner.onnx")
  model.predict(phrase)
end

def text_generation(phrase:, max_length: 50)
  model = Informers::TextGeneration.new("./models/text-generation.onnx")
  model.predict(phrase, max_length: max_length)
end

def feature_extraction(phrase:)
  model = Informers::FeatureExtraction.new("./models/feature-extraction.onnx")
  model.predict(phrase)
end

def fill_mask(phrase:)
  model = Informers::FillMask.new("./models/fill-mask.onnx")
  model.predict(phrase)
end

def perform(cmd, **args)
  begin
    results = send(cmd.to_sym, **args)
    whoop(cmd.to_s, context: args, color: :yellow) { results }
    results
  rescue => ex
    puts "#{ex.message}".red
  end
end

# perform :predict_sentiment, 
#   values: [
#     "This is amazing!",
#     "I'm not sure if this is the right approach.",
#     "I am trying to think of good things to say, but I can't."
#   ]
#
# perform :question_answering,
#   question: "Who invented Ruby?",
#   context: "Ruby is a programming language created by Matz"
#
# perform :named_entity_recognition,
#   phrase: "Nat works at GitHub in San Francisco"

perform :text_generation,
  phrase: "As far as I am concerned, I will",
  max_length: 50

perform :feature_extraction,
  phrase: "This is super cool"

perform :fill_mask,
  phrase: "This is a great <mask>"
