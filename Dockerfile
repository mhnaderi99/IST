FROM ubuntu:22.04 as build

RUN apt update
RUN apt install python3 python3-pip -y
RUN apt install wget -y
RUN apt install curl -y

RUN mkdir 'data_speech_commands_v0.02'
RUN mkdir 'log'
RUN mkdir 'trained_models'
RUN mkdir 'figures'
RUN wget -O 'data_speech_commands_v0.02.tar.gz' 'https://www.googleapis.com/drive/v3/files/1_8vKH2josMvwCQNacMRP74wNUc5E3yMZ?alt=media&key=AIzaSyANQ-ZW5Jc40JlxdoWuSBaAmZtbc9E466g'
RUN tar -xvf 'data_speech_commands_v0.02.tar.gz' -C 'data_speech_commands_v0.02/'

COPY requirements.txt ./
RUN pip3 install -r requirements.txt

FROM ubuntu:22.04 as target

COPY distributed_2layer_subnet_centralized_ps_gloo.py ./
COPY distributed_3layer_subnet_centralized_ps_gloo.py ./
COPY google_speech_data_loader.py ./
COPY ist_utilis.py ./

COPY --from=build ./ ./
RUN python3 "./google_speech_data_loader.py"
# ENTRYPOINT ["python3", "./distributed_2layer_subnet_centralized_ps_gloo.py"]
# CMD ["python3", "./distributed_2layer_subnet_centralized_ps_gloo.py"]
ENTRYPOINT ["python3", "./distributed_3layer_subnet_centralized_ps_gloo.py"]
CMD ["python3", "./distributed_3layer_subnet_centralized_ps_gloo.py"]