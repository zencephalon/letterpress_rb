require "nokogiri"
require "open-uri"

class Letterpress

    def words_containing(letters)
        doc = Nokogiri::HTML(open("http://www.wordhippo.com/what-is/words-containing/#{letters}.html"))
        return nil if doc.text.match("No words found")
        doc.text.split("
    end

end
