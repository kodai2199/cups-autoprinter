This docker image is a [debian-based CUPS Print Server](https://hub.docker.com/r/olbat/cupsd) that includes a simple script to print PDF files automatically.

Github: https://github.com/kodai2199/cups-autoprinter<br/>
Docker: https://hub.docker.com/r/avatar2199/cups-autoprint/<br/>
Let me know on Github if you have any issues or feature requests!

# <div align="center">Documentation</div>
## <div align="center">Getting started</div>
The [documentation for the base CUPS image](https://hub.docker.com/r/olbat/cupsd) still applies, but the base commands changes to:<br/>
`docker run -d -p 631:631 -v /var/run/dbus:/var/run/dbus -v FILE_SOURCE_FOLDER:/home/print/to_print -v $FILE_DESTINATION_FOLDER:/home/print/printed -v CUPS_SETTINGS_FOLDER:/etc/cups --name cupsd avatar2199/cups-autoprint`
## <div align="center">The autoprint script</div>
The autoprint script prints all the .pdf files inside the source folder (`/home/print/to_print`, from the container point of view) and moves them to the output folder (`/home/print/printed`). For now, the script has only four parameters, supplied as environment variables, that determine the "work hours":
- `WORK_START_HOUR` (default 8)
- `WORK_STOP_HOUR` (default 12)
- `WORK_START_DAY` (default 1, being Monday)
- `WORK_STOP_DAY` (default 6, being Friday)

Which means that by default the autoprint script will print and move files only between 8:00 and 11:59 from Monday to Friday. The start and stop indices work like they do in Python: start is included, stop is excluded. This was mainly introduced because in my case there are restrictions on the printer work hours.<br/>Tip: pay attention to time syncing inside your container! For example, run the `date` command inside your container to check that the time is correctly set. 

If you want to disable this feature entirely, just set your "START" environment variables to 0, and the "STOP" environment variables to 24.

## <div align="center">Additional considerations on CUPS</div>
### <div align="center">Saving your CUPS settings</div>
The option introduced above, `-v CUPS_SETTINGS_FOLDER:/etc/cups` allows you to define the folder where CUPS will save its settings, and where you can place your custom cupsd.conf.

### <div align="center">Open files limit</div>
On some distributions and docker versions, the CUPS server might not work properly. As shown in [this StackOverflow question](https://stackoverflow.com/a/75634670), this can be caused by cupsDoSelect failing when the maximum number of open files is very large or unlimited. In this case the solution is to use `--ulimit nofile=<soft limit>:<hard limit>` option to change the limit of open files for the container. 

Simply run the container adding the option next to the run command:<br/> `docker run --ulimit nofile=1024:1024 `

Versions where this issue has been tested or reported:
- Manjaro Linux & Docker 24.0.6

## <div align="center">Example docker-compose.yaml</div>
For quick use with docker commpose, you can use the following as a template:

```yaml
services:
  cups:
    container_name: cupsd
    image: avatar2199/cups-autoprint
    volumes:
      - /var/run/dbus:/var/run/dbus
      - /mnt/user/appdata/cups:/etc/cups/
      - PDF SOURCE FOLDER:/home/print/to_print
      - PDF DESTINATION FOLDER:/home/print/printed
    ports:
      - "631:631/tcp"
    environment:
      - WORK_START_HOUR=8
      - WORK_STOP_HOUR=12 # So it will stop at 11:59. 12:00 and later is excluded
      - WORK_START_DAY=1
      - WORK_STOP_DAY=6 # So it will stop on Friday. Satuday and Sunday are excluded in this way.
```

## <div align="center">Notes</div>
I am thinking about adding options to support more file types (.txt, .jpg, ...), perhaps with the use of an environment variable.
