FROM python:3.11.3

ARG USERNAME=rfuser
ARG TEST_RUNNER_UID=1001
ARG TEST_RUNNER_GID=$TEST_RUNNER_UID

ENV ROBOT_DIR /opt/robotfw
ENV ROBOT_WORK_DIR ${ROBOT_DIR}/temp
ENV ROBOT_TESTS_DIR ${ROBOT_DIR}/tests
ENV PYTHONPATH ${PYTHONPATH}:${ROBOT_TESTS_DIR}
ENV TZ Europe/Helsinki

RUN groupadd --gid $TEST_RUNNER_GID $USERNAME \
    && useradd --uid $TEST_RUNNER_UID --gid $TEST_RUNNER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN mkdir -p ${ROBOT_WORK_DIR} \
    && mkdir -p ${ROBOT_TESTS_DIR} \
    && chown -R ${TEST_RUNNER_UID}:${TEST_RUNNER_GID} ${ROBOT_DIR} \
    && chmod -R ugo+w ${ROBOT_DIR}

WORKDIR ${ROBOT_WORK_DIR}

COPY requirements.txt requirements.txt

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo ${TZ} > /etc/timezone

USER $USERNAME

ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

# Install robot framework and other deps
RUN pip3 install -r requirements.txt

WORKDIR ${ROBOT_TESTS_DIR}

CMD [ "robot ." ]
