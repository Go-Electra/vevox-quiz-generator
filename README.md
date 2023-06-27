# Vevox quiz as-code

This Ruby project allows you to create a Vevox QCM quiz in `as-code`.

You just have to prepare a json file with your question and generate a zip file to import in Vevox plateform.

## Benefits of the `as-code` 

- Can restore a quiz in an instant (if any problem)
- Share the quiz to other
- Versioning of the quiz
- Allow to improve the quiz generator, for example:
  - randomize the order of the questions or the answers.
  - create a big pool of question, then generate random sub-selections as a quiz

## Requirements

- Ruby 3

## Procedure

### 1/ Prepare your questions (`input` folder)

If you've added a new quiz, you'll have to add the quiz name in the last line of `vevox.rb` 

### 2/ Generate the zip files

```shell
ruby vevox.rb
```

zip files can be found in `output` folder

### 3/ Import the zip in your vevox quiz (https://www.vevox.com)

## Limitations

For now, the quiz generator can only manage `MultipleChoiceQuestion` types (my needs)

but it should be possible to extand it to anything
