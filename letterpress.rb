require "nokogiri"
require "open-uri"

class Letterpress
    def initialize(letters)
        @cache, @letters_hash = {}, {}
        @dict = File.open('words/Words/en.txt', 'r').readlines.map(&:chomp)
        ('a'..'z').each do |letter|
            @letters_hash[letter] = letters.count letter
        end
        @small_dict = @dict.reject {|word| no_letters(word)}.sort_by(&:length)
    end

    def words_containing(letters)
        return @cache[letters] if !@cache[letters].nil?
        letters_regex = /#{letters.chars.join(".*")}/
        words = []
        @small_dict.each do |word|
            words << word if word.match(letters_regex)
        end
        @cache[letters] = words
    end

    def words(letters_contain = nil)
        return @small_dict if letters_contain.nil?

        w, perms = [], letters_contain.chars.permutation.to_a

        puts "Checking #{perms.length} permutations:"

        i = 1
        perms.each do |perm|
            puts "#{i}: #{perm.join}"
            w += words_containing(perm.join)
            i += 1
        end

        return nil if w.empty?

        w.reject! {|word| no_letters(word)}
        w.sort_by(&:length)
    end

    def no_letters(word)
        @letters_hash.each do |letter, num|
            return true if word.count(letter) > num
        end
        return false
    end
end
