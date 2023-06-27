require "json"
require "logger"
require "zip"

INPUT_FOLDER = "input"
OUTPUT_FOLDER = "output"
POLLS_FILENAME = "polls.json"
FINAL_QUESTIONS = "final"

class Vevox
  attr_reader :sequence, :log, :quiz

  def initialize(quiz)
    @sequence = 0
    @log = Logger.new(STDOUT)
    @quiz = quiz
  end

  def get_sequence
    @sequence = sequence + 1
    sequence.to_s
  end

  def execute
    data_hash = JSON.dump(
      transform(load_input(quiz)) + transform(load_input(FINAL_QUESTIONS))
    )
    zip(data_hash)
    log.debug("DONE")
  end

  private

  def load_input(quiz)
    flow = File.read("#{INPUT_FOLDER}/#{quiz}.json")
    log.debug("Load flow:\n #{flow}")
    JSON.parse(flow)
  end

  def transform(json)
    json.map { |poll| payload(poll) }
  end

  def payload(poll)
    {
      "@type": "MultipleChoiceQuestion",
      "lowerCaseAlias": "",
      "id": get_sequence,
      "alias": "",
      "text": poll.fetch("question"),
      "image": nil,
      "imageAltText": "",
      "choices": poll.fetch("answers").map do |answer|
        {
          "id": get_sequence,
          "alias": nil,
          "text": answer.fetch("label"),
          "excludeFromResults": poll.fetch("exclude", false),
          "image": nil,
          "isCorrectAnswer": answer.fetch("good", false)
        }
      end,
      "minNumberSelections": 1,
      "maxNumberSelections": 1,
      "resultFormat": "%",
      "distributableWeight": nil,
      "weightingSetting": nil,
      "weightingFactor": nil,
      "correctAnswerExplanation": poll.fetch("comment", ""),
      "resultSorting": nil
    }
  end

  def zip(data_hash)
    output_file = "#{OUTPUT_FOLDER}/#{quiz}.zip"
    File.delete(output_file) if File.exist?(output_file)
    stringio = Zip::OutputStream::write_buffer do |zio|
      zio.put_next_entry(POLLS_FILENAME)
      zio.write(data_hash)
    end
    stringio.rewind # Reposition buffer pointer to the beginning
    File.new(output_file, "wb").write(stringio.sysread) # Write buffer to zipfile
  end
end

%w[5_electra 50_tech].each { |quiz| Vevox.new(quiz).execute }
