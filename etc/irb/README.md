### Kurulum

- Ruby 1.9.x kurulumunun eksiksiz olduğunda emin olun.

        sudo apt-get install ruby1.9.1-full

- Gerekli gem'leri kurun.

        sudo gem install irbtools irbtools-more highline

- İsteğe bağlı olarak bazı paket ve gem'leri de kurun.

        sudo apt-get install xclip tk-tile graphviz
        sudo gem install rdp-arguments methopara

### Özelleştirme

**Lütfen mevcut dosyalara dokunmayın.**  Özelleştirme yapmak için uygun
şekilde numaralandırılmış `.rb` uzantılı bir dosyayı bu dizine koyun (örneğin
`70-local.rb`).
