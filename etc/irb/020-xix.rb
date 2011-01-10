# encoding: utf-8

module Xix
  module Irb
    def bilgi
      cheat_sheet = <<INFO
--------------------------------------------------------------------------------
Bilgi
--------------------------------------------------------------------------------

o                       "o" nesnesini görüntüle
o.m                     "o" nesnesini metodlarla birlikte görüntüle
o.see                   "o" nesnesini grafik ortamda görselleştir
o.ri :metod             "o" nesnesinde ':metod' dokümanını görüntüle
o.interesting_methods   "o" nesnesindeki metodları özet olarak görüntüle

ri "C#m"                "C" sınıfındaki "m" metoduna ait dokümanı görüntüle

Clipboard.copy          Seçileni panoya kopyala
Clipboard.paste         Panodan yapıştır

_                       Bir önceki ifadenin ürettiği sonuç
var = _                 'var' değişkenine bir önceki ifadenin sonucunu ata

quick       { ... }     Bloğun ortalama çalışma süresini (100 yinelemeyle) ölç
quick(1000) { ... }     Bloğun ortalama çalışma süresini 1000 yinelemeyle ölç

irb                     Yeni oturum aç
jobs                    Oturumları listele
fg 2                    2 numaralı oturuma geç
exit                    Oturumu kapat  (Ctrl-D tuşu da kullanılabilir)
reset!                  Çalışma ortamını sıfırla
clear                   Ekranı temizle  (Ctrl-L tuşu da kullanılabilir)

e                       Son düzenlenen dosyayı aç
e :b                    "b" referanslı dosyayı, son düzenlenen değişmeden aç
e!                      Yeni dosya aç
e! :b                   "b" referanslı dosyayı aç ve son düzenlenen olarak ata
e?                      Düzenlenecek dosyayı seç
ed                      Geçici bir dosya aç
--------------------------------------------------------------------------------
INFO
      puts cheat_sheet.green
    end

  end
end

include Xix::Irb

# Alternatif olarak "CodeDiary" var.
Irbtools.remove_library :sketch

Irbtools.welcome_message = "#{RUBY_DESCRIPTION.capitalize} çalışma ortamına hoşgeldiniz!  Kısa bilgi için 'bilgi' yazın."
