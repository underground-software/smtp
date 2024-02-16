FROM fedora:latest AS build
RUN dnf -y update
RUN dnf -y install \
	git \
	musl-clang \
	musl-libc-static \
	make \
	;

ADD . /smtp

RUN git -C /smtp submodule update --init --recursive

RUN make -C /smtp/tcp_server CC='musl-clang -static'

ARG hostname
RUN test -n "$hostname" || (echo 'hostname is not set' && false)

RUN make -C /smtp CC='musl-clang -static' SRVNAME=$hostname

RUN mkdir -p /mnt/email_data/mail /mnt/email_data/logs

#FROM fedora:latest as smtp
#RUN dnf -y update && dnf -y install libselinux-utils && dnf clean all
FROM scratch as smtp
COPY --from=build /mnt/email_data /mnt/email_data
VOLUME /mnt/email_data/
COPY --from=build /smtp/tcp_server/tcp_server /usr/local/bin/tcp_server
COPY --from=build /smtp/smtp /usr/local/bin/smtp

EXPOSE 465
ENTRYPOINT ["/usr/local/bin/tcp_server", "-p", "465", "/usr/local/bin/smtp", "smtp", "/mnt/email_data"]