require "nokogiri"
require "open-uri"

class Letterpress
    def initialize(letters)
        @cache, @letters_hash = {}, {}
        letters.chars.each do |letter|
            @letters_hash[letter] = letters.count letter
        end
    end

    def words_containing(letters)
        return @cache[letters] if !@cache[letters].nil?
        doc = Nokogiri::HTML(open("http://www.wordhippo.com/what-is/words-containing/#{letters}.html"))
        return [] if doc.text.match("No words found")
        words = doc.text.split("Words Found")[1].split("Search Again!")[0].split
        i = 2
        while true
            doc = Nokogiri::HTML(open("http://www.wordhippo.com/what-is/words-containing/#{letters}.html?page=#{i}"))
            break if doc.text.match("No words found")
            words += doc.text.split("Words Found")[1].split("Search Again!")[0].split
            i += 1
        end
        @cache[letters] = words
        words
    end

    def words(letters_contain)
        w = []
        letters_contain.chars.permutation do |perm|
            w += words_containing(perm.join)
        end
        return nil if w.empty?
        w.reject! {|word| no_letters(word)}
        w
    end

    def no_letters(word)
        @letters_hash.each do |letter, num|
            return true if word.count(letter) > num
        end
        return false
    end
end
