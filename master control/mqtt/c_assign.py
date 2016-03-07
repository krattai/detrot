#!/usr/bin/env python

# Copyright (C) 2016 Uvea I. S., Kevin Rattai
# This software is based on an unknown license, but is available
# with no license statement from here:
# http://stackoverflow.com/questions/31775450/publish-and-subscribe-with-paho-mqtt-client
#
# All changes will be under BSD 2 clause license.  Code of unknown license
# will be removed and replaced with code that will be BSD 2 clause
#
# Portions of this code is based on the noo-ebs project:
#     https://github.com/krattai/noo-ebs
#
# And portions of this code is based on the AEBL project:
#     https://github.com/krattai/AEBL
#
# Obviously, in this first instance of noo-ebs for test and
# production, this script installs MQTT
#
# The goal is to eventually move to, or at least add as a
# supplemental, a peer to peer message queue system, most likely nanomsg

import os
import paho.mqtt.client as mqtt

# reference to MQTT python found here: http://mosquitto.org/documentation/python/

# requires:  sudo pip install paho-mqtt
# pip requires: sudo apt-get install python-pip

message = 'ON'
def on_connect(mosq, obj, rc):
# subscribe([("my/topic", 0), ("another/topic", 2)])
#    mqttc.subscribe("aebl/alive", 0)
    mqttc.subscribe("request/chan", 0)
    print("rc: " + str(rc))

def on_message(mosq, obj, msg):
    global message
    print(msg.topic + " " + str(msg.qos) + " " + str(msg.payload))
    message = msg.payload
    mqttc.publish("response/" + str(msg.payload),msg.payload);
#    if 'ACK' in message:
#        mqttc.publish("uvea/world","NAK");
#    if 'XCHNG' in message:
#        os.system("/home/kevin/scripts/xchng.sh")
#         mqttc.publish("aebl/alive","NAK");
#    mqttcb.publish("aebl/alive",msg.payload);

def on_publish(mosq, obj, mid):
    print("mid: " + str(mid))

def on_subscribe(mosq, obj, mid, granted_qos):
    print("Subscribed: " + str(mid) + " " + str(granted_qos))

def on_log(mosq, obj, level, string):
    print(string)

mqttc = mqtt.Client()
# Assign event callbacks
mqttc.on_message = on_message
mqttc.on_connect = on_connect
mqttc.on_publish = on_publish
mqttc.on_subscribe = on_subscribe

# Connect
# mqttc.connect("localhost", 1883,60)

# Will ultimately use Uvea / AEBL broker by name
mqttc.connect("ihdn.ca", 1883,60)
# mqttc.connect("2001:5c0:1100:dd00:ba27:ebff:fe2c:41d7", 1883,60)

# mosquitto_sub -h 2001:5c0:1100:dd00:ba27:ebff:fe2c:41d7 -t "hello/+" -t "aebl/+" -t "ihdn/+" -t "uvea/+"

# Continue the network loop
mqttc.loop_forever()

