FROM olbat/cupsd:latest
COPY --chown=print:print --chmod=740 ./autoprint.sh /home/print/autoprint.sh
ENV WORK_START_HOUR=8 WORK_STOP_HOUR=12 WORK_START_DAY=1 WORK_STOP_DAY=6
CMD /usr/sbin/cupsd -f & cd /home/print && ./autoprint.sh > /home/print/printed/printed.log 2>&1
VOLUME /home/print/to_print
VOLUME /home/print/printed
VOLUME /etc/cups