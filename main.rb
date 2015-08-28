require "mp3info"
require "byebug"
require 'rchardet'

class Main  

  def initialize(param)
    base = "H:\\Music\\עברי\\א-ב-ג\\".encode('utf-8')
    Dir.entries(base).each do |dir|
      artist = dir.encode('utf-8')
      artist_path = File.join(base,artist)
      #puts artist_path
      if is_directory?(artist_path, dir)
        Dir.entries(artist_path).each do |dir|
          album = dir.encode("utf-8")
          album_path = File.join(artist_path, album)
          if is_directory?(album_path, dir)
            Dir.entries(album_path).each do |file_or_dir|
              file_or_dir = file_or_dir.encode("utf-8")
              file_or_dir_path = File.join(album_path, file_or_dir)
              if is_directory?(file_or_dir_path, file_or_dir)
                Dir.entries(file_or_dir_path).each do |nested_dir_file|
                  nested_dir_file = nested_dir_file.encode("utf-8")
                  handle_song(artist, album + " (" + file_or_dir + ")", nested_dir_file, file_or_dir_path)
                end
              else
                handle_song(artist, album, file_or_dir, album_path)
              end
            end
          end
        end
      end
    end
  end

  def is_directory?(path, dir)
    File.directory?(path) && dir!=".." && dir!="."
  end

  def handle_song(artist, album, song, path)
    song = song.encode('utf-8')
    if song.match /(.*\.mp3)|(.*\.m4p)|(.*\.flac)/
      song = path + "\\" + song
      Mp3Info.open(song) do |mp3info|
        puts artist
        puts album
        puts song
        mp3info.tag2.TPE2 = artist
        mp3info.tag.album = album
        mp3info.tag.artist = artist if mp3info.tag.artist.nil?
      end
    end
  end
end

Main.new("guy")