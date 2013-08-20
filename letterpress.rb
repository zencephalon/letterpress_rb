require "nokogiri"
require "open-uri"

class Letterpress
    def words_containing(letters)
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
        words
    end
end
