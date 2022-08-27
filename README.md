# Storia-Spider
Spider writen in racket, downloading and decryting mange from storia.takeshobo.co.jp

usage:
```
racket main.rkt [manga-name] [chapter-name] [start-number] [end-number]
# exp:
racket main.rkt osakano 01 1 30
```

Reminding that some chapter does not start from 1, so you need to set start-number to 2, etc.

Then this script will download and save the decryted pictures in manga-name/chapter-name/
