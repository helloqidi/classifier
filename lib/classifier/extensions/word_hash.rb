# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

require 'rmmseg'
require "set"
RMMSeg::Dictionary.load_dictionaries

# These are extensions to the String class to provide convenience 
# methods for the Classifier package.
class String
  
  # Removes common punctuation symbols, returning a new string. 
  # E.g.,
  #   "Hello (greeting's), with {braces} < >...?".without_punctuation
  #   => "Hello  greetings   with  braces         "
  def without_punctuation
    tr( ',?.!;:"@#$%^&*()_=+[]{}\|<>/`~', " " ) .tr( "'\-", "")
  end
  
  # Return a Hash of strings => ints. Each word in the string is stemmed,
  # interned, and indexes to its frequency in the document.  
	def word_hash
		word_hash = clean_word_hash()
		#symbol_hash = word_hash_for_symbols(gsub(/[\w]/," ").split)
		symbol_hash = word_hash_for_symbols(gsub(/[\w(\p{Han}+)]/u," ").split)
		return word_hash.merge(symbol_hash)
	end

  #获得分伺后的数组
  def chinese_segment_array(the_text)
    segment_array = []
    algor = RMMSeg::Algorithm.new(the_text)
    loop do
      tok = algor.next_token
      break if tok.nil?
      segment_array << tok.text.force_encoding('UTF-8')
    end
    return segment_array
  end

	# Return a word hash without extra punctuation or short symbols, just stemmed words
	def clean_word_hash
		#word_hash_for_words gsub(/[^\w\s]/,"").split
    #发现\w不能匹配中文
    #word_hash_for_words(chinese_segment_array(gsub(/[^\w\s]/,"")))
    #匹配汉字用 /\p{Han}+/u 就可以了
    word_hash_for_words(chinese_segment_array(gsub(/[^\w\s(\p{Han}+)]/u,"")))
	end
	
	private
	
	def word_hash_for_words(words)
		d = Hash.new(0)
		words.each do |word|
			word.downcase!
      #中文判断是2个汉字起
      if if_contain_chinese_word?(word)
        judge_length = 1
      #英文判断是3个字符起
      else
        judge_length = 2
      end
      if ! CORPUS_SKIP_WORDS.include?(word) && word.length > judge_length
        #d[word.stem.intern] += 1
        d[word.stem.force_encoding('UTF-8').intern] += 1
      end
		end
		return d
	end

  #是否包含中文.包含中文返回true
  def if_contain_chinese_word?(word)
    result = word =~ /\p{Han}+/u
    result==nil ? false : true
  end

	def word_hash_for_symbols(words)
		d = Hash.new(0)
		words.each do |word|
			d[word.intern] += 1
		end
		return d
	end
	
  #跳过不记录的单词
	CORPUS_SKIP_WORDS = Set.new([
      "a",
      "again",
      "all",
      "along",
      "are",
      "also",
      "an",
      "and",
      "as",
      "at",
      "but",
      "by",
      "came",
      "can",
      "cant",
      "couldnt",
      "did",
      "didn",
      "didnt",
      "do",
      "doesnt",
      "dont",
      "ever",
      "first",
      "from",
      "have",
      "her",
      "here",
      "him",
      "how",
      "i",
      "if",
      "in",
      "into",
      "is",
      "isnt",
      "it",
      "itll",
      "just",
      "last",
      "least",
      "like",
      "most",
      "my",
      "new",
      "no",
      "not",
      "now",
      "of",
      "on",
      "or",
      "should",
      "sinc",
      "so",
      "some",
      "th",
      "than",
      "this",
      "that",
      "the",
      "their",
      "then",
      "those",
      "to",
      "told",
      "too",
      "true",
      "try",
      "until",
      "url",
      "us",
      "were",
      "when",
      "whether",
      "while",
      "with",
      "within",
      "yes",
      "you",
      "youll",
      ])
end
