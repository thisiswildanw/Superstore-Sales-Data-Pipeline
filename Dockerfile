FROM python:3.9
COPY python-file/* ./
RUN pip install -r requirements.txt
RUN echo "Asia/Jakarta" > /etc/timezone
ENTRYPOINT [ "python", "drive_gcs_intgr.py" ]
