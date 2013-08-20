require "nokogiri"
require "open-uri"

class Letterpress
    def initialize
        @cache = {}
    end

    def words_containing(letters)
        return @cache[letters] if !@cache[letters].nil?
        doc = Nokogiri::HTML(open("http://www.wordhippo.com/what-is/words-containing/#{letters}.html"))
        return nil if doc.text.match("No words found")
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

    def words(letters_contain, letters_not)
        w = words_containing(letters_contain)
        return nil if w.nil?
        w.reject! {|word| contains_banned_letter(word, letters_not)}
        w
    end

    def contains_banned_letter(word, letters)
        letters.chars.each do |letter|
            return true if word.include? letter
        end
        return false
    end
end
