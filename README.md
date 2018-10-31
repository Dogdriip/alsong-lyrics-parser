# alsong-lyrics-parser 
[![Code Climate](https://codeclimate.com/github/Dogdriip/alsong-lyrics-parser/badges/gpa.svg)](https://codeclimate.com/github/Dogdriip/alsong-lyrics-parser)

알송 가사를 파싱해오는 간단한 모듈입니다. [Ruby 프로그래밍 언어](https://github.com/ruby/ruby)로 작성되었습니다.

## 사용법
alsong 모듈을 require하여 사용할 수 있습니다.
```
require_relative 'modules/alsong'
```
## Alsong.get_lyrics(title, artist=" ")
가사를 검색하여 곡 정보와 함께 json 형식으로 돌려줍니다.

* title: 가사를 검색하려는 노래의 제목
* artist: 가사를 검색하려는 노래의 아티스트 (기본값: " ")

예제:
```ruby 
puts Alsong.get_lyrics "ケロ⑨destiny"
puts Alsong.get_lyrics "ベースラインやってる？笑", "ななひら"
```
> 정확한 아티스트 명을 모를 때에는 artist 인자를 전달하지 않아도 됩니다.

json 반환 예제:
```json
[{"title":"ケロ⑨destiny","artist":"Silver Forest","album":"東方蒼天歌"},{"time":"00:00.43","text":" ... "},{"time":"00:00.43","text":" ... "},...]
```
> 첫 object는 검색한 노래의 제목, 아티스트, 앨범명으로 이루어져 있으며, 이후 가사 정보를 담은 object가 반복됩니다.
> 가사 object는 가사의 출력 시간, 가사 내용으로 이루어져 있습니다.

## TODO
* 시간을 ms로 변환하여 반환
* 같은 시간에 할당된 가사들 (최대 3줄?) 합쳐서 반환
* json 외의 다른 형식으로 반환하는 함수 추가
* 에러핸들링...언제...해...

## 참고
* 알송 (http://www.altools.co.kr/Brand/Alsong/)
