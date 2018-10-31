# author  driip
# date    160227

require 'net/http'
require 'uri'
require 'json'

module Alsong
  $alsong_uri = URI.parse 'http://lyrics.alsong.co.kr/alsongwebservice/service1.asmx'
  def Alsong.get_lyrics title, artist=" "
    xml_string = '<?xml version="1.0" encoding="UTF-8"?>' + 
                 '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope" ' + 
                                    'xmlns:SOAP-ENC="http://www.w3.org/2003/05/soap-encoding" ' + 
                                    'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' + 
                                    'xmlns:xsd="http://www.w3.org/2001/XMLSchema" ' + 
                                    'xmlns:ns2="ALSongWebServer/Service1Soap" ' + 
                                    'xmlns:ns1="ALSongWebServer" ' + 
                                    'xmlns:ns3="ALSongWebServer/Service1Soap12">' + 
                    '<SOAP-ENV:Body>' + 
                      '<ns1:GetResembleLyric2>' + 
                        '<ns1:stQuery>' + 
                          '<ns1:strTitle>' + title + '</ns1:strTitle>' + 
                          '<ns1:strArtistName>' + artist + '</ns1:strArtistName>' + 
                          '<ns1:nCurPage>0</ns1:nCurPage>' + 
                        '</ns1:stQuery>' + 
                      '</ns1:GetResembleLyric2>' + 
                    '</SOAP-ENV:Body>' + 
                  '</SOAP-ENV:Envelope>'
    req = Net::HTTP::Post.new $alsong_uri.request_uri
    # Content-Type := type "/" subtype *[";" parameter] 
    req.content_type = "text/xml;charset=utf-8"
    req.body = xml_string

    res = Net::HTTP.start $alsong_uri.hostname, $alsong_uri.port do |session|
      session.request req
    end
    begin
      case res
      when Net::HTTPSuccess
        raise "Empty response" if res.body.nil? or res.body.empty?
        resarr = Array.new
        
        song_title = res.body.split("<strTitle>")[1].split("</strTitle>")[0]
        song_artist = res.body.split("<strArtistName>")[1].split("</strArtistName>")[0]
        song_album = res.body.split("<strAlbumName>")[1].split("</strAlbumName>")[0]
        # Hash for to_json
        song_info = {"title" => song_title.force_encoding('UTF-8'), "artist" => song_artist.force_encoding('UTF-8'), "album" => song_album.force_encoding('UTF-8')}
        resarr.push song_info
                
        lyrics = res.body.split("<strLyric>")[1].split("</strLyric>")[0].split("br")
        # debugging
        lyrics.pop
        lyrics.each do |lyric|
          lyric_time = lyric.split('[')[1].split(']')[0]
          lyric_text = lyric.split(']')[1].split('&')[0]
          lyric_arr = {"time" => lyric_time, "text" => lyric_text.force_encoding('UTF-8')}
          resarr.push lyric_arr
          # puts lyric_time_ + " / " + i.to_s
        end
        return resarr.to_json
      else
        raise "Cannot send POST request"
      end
    rescue Exception => e
      return "Exception occured at #{e.backtrace.inspect}: #{e.message}"
    end
    # return res.body
  end
end
