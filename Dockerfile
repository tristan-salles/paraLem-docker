FROM tristansalles/paralem-core:latest

RUN find /live/lib/LavaVu/notebooks -name \*.ipynb  -print0 | xargs -0 jupyter trust

RUN pip install pygeotools

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends apt-utils

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python-numpy \
    gdal-bin \
    libgdal-dev
    
RUN pip install rasterio

RUN sed -i 's/86400/-1/g' /root/.config/pipdate/config.ini

# note we also use xvfb which is required for viz
ENTRYPOINT ["/usr/local/bin/tini", "--", "xvfbrun.sh"]

# setup space for working in
VOLUME /live/share

WORKDIR /live
# expose notebook port
EXPOSE 8888

# expose LavaVu port
EXPOSE 9999

ENV LD_LIBRARY_PATH=/live/lib/:/live/share

# launch notebook
CMD ["jupyter", "notebook", " --no-browser", "--allow-root", "--ip=0.0.0.0", "--NotebookApp.iopub_data_rate_limit=1.0e10"]
