#!/bin/sh

# According to this thread (https://groups.google.com/g/rabbitmq-users/c/AdkDZhmYtAA)
# RabbitMQ will reload its certificate files automatically. So, this command
# may not be necessary:
rabbitmqctl eval 'ssl:clear_pem_cache().'
