module Story where

import DataModel exposing (..)

story : List Layout
story = [
  SinglePaneStep
  {
    header = HeaderPane {content = [Single """
## Welcome to the ALICE O2 Primer tutorial.
Use arrow keys to navigate.
""", Replace """
## Welcome to the ALICE O2 Primer tutorial.

The purpose of this tutorial is to guide you step by step through the set up of
your O2 working environment, the creation of your own FairRoot devices and
their deployment using DDS.

**Now lets get started!**
""", Append """
First of all this tutorial assumes you are in `~/alice` and that's
what we will use as a workarea. Notice that we set the `WORK_DIR`
environment variable to it.
"""]},
    pane = ShellPane { content = [Single "\n$\n", Reuse, Replace """
$ mkdir -p ~/alice 

$ cd ~/alice

$ pwd
/Users/me/alice

$ export WORK_DIR=$PWD
"""] }
  },

  SinglePaneStep
  {
    header = HeaderPane {content = [Single """
## Setting up your environment

The first thing to do is make sure you have O2 and all
the required software installed. To do so you can use
[aliBuild](http://alisw.github.io/alibuild/) a simple script which will
build everything and provide you with an easy to setup work environment.

""",
  Append "alibuild is hosted on Github and you can easily get it using `git clone`.",
  Append """
  Once you have downloaded alibuild itself, you need to download the
recipes which describe your software distribution, these are maintained in a separate project
called `alidist`.
""", Append """Since in this particular case we want to also develop
inside O2, we checkout its sources making sure they are at the same
level as `alidist`. Notice how we pick up the `dev` branch for
development.
""", Replace """
## Building the software

You can build the software by issuing the `aliBuild build` command.
`aliBuild` will try its best to reuse what you have on your system and
(eventually) download prebuild software instead of recompiling. You can find in depth documentation for alibuild at
<https://alisw.github.io/alibuild>.
"""
  ]},
    pane = ShellPane {
      content = [ Single """
$
""",
                  Single """
$ git clone https://github.com/alisw/alibuild
""",
                  Append """
$ git clone -b IB/v5-06/next https://github.com/alisw/alidist
""",              Append """
$ git clone -b dev https://github.com/AliceO2Group O2
""",
                  Append """
$ alibuild/aliBuild build O2
"""
  ]}
  },

  SinglePaneStep
  {
    header = HeaderPane {content = [Single """
## Directory structure

After a few minutes of building, aliBuild should finish successfully
and you should be left with an "sw" folder where the O2 software is
installed.""",
  Append """Alibuild builds each package in a separate hierarcy
`sw/<architecture>/<package>/<version>` where:
- `<architecture>` is the architecture of your platform (e.g.
`osx_x86-64`, `slc7_x86-64` or `ubuntu1510_x86-64`).""", 
  Append """
- `<package>` is the name of the package.""", 
  Append """
- `<version>` is the version of the package.
"""]},
    pane = ShellPane { content = [ Single """
$ ls sw
BUILD       INSTALLROOT MIRROR      SOURCES
SPECS       TARS        osx_x86-64
""", Append """
$ ls sw/osx_x86-64
AliEn-CAs             GEANT3                MonALISA-gSOAP-client cgal                  nanomsg
AliEn-Runtime         GEANT4                O2                    defaults-release      protobuf
AliPhysics            GEANT4_VMC            ROOT                  fastjet               pythia
AliRoot               GMP                   UUID                  gSOAP                 pythia6
ApMon-CPP             GSL                   XRootD                generators            simulation
DDS                   HepMC                 ZeroMQ                glog                  sodium
FairRoot              MPFR                  boost                 lhapdf                xalienfs
""", ReplaceLast """
$ ls sw/osx_x86-64
...                   AliPhysics            AliRoot               O2 ...              

$ ls sw/osx_x86-64/O2
latest   master-1 master-2
""", Append """
$ ls sw/osx_x86-64/O2/latest
bin            etc            include        lib            relocate-me.sh share
"""]
    }
  },

  SinglePaneStep
  {
    header = HeaderPane { content = [Single """
## Setting up the environment

Once we have our O2 software built, we need to set up the environment in order to run O2 executables.
""", Append """
For each of the packages it builds, alibuild creates an `init.sh` file in `<package>`/etc/init.sh which
once sourced will set up all the required paths for the package itself and its dependencies.
""", Append """
You can verify you have the correct environment by looking for some of the pre-built O2 utilities.
"""]},
    pane = ShellPane {content = [ Single"""
$ ls sw/osx_x86-64/O2/latest
bin            etc            include        lib            relocate-me.sh share
""", Append """
$ ls $PWD/sw/osx_x86-64/O2/latest/etc/profile.d/init.sh
/Users/me/alice/sw/osx_x86-64/O2/latest/etc/profile.d/init.sh
""", Append """
$ WORK_DIR=$PWD/sw source sw/osx_x86-64/O2/latest/etc/profile.d/init.sh
""", Append """
$ which testFlp
/Users/me/alice/sw/osx_x86-64/O2/master-1/bin/testFlp

$ which dds-server
/Users/me/alice/sw/osx_x86-64/DDS/master-1/bin/dds-server
""" ] }
  },

  ImageStep
  {
    header = HeaderPane { content = [Single """
## O2 / FairRoot architecture : Devices

Let's now try to create a new O2 process which does some sort of
data-processing. O2 describes processing workflows in terms of so called
devices. Devices are instances of the `FairMQDevice` class and they
provide implement computation and communication with other devices.
"""]},
    image = "device.png"
  },

  ImageStep
  {
    header = HeaderPane { content = [Single """

## O2 / FairRoot architecture : Topologies

A group of devices can be linked together in what is called a ``topology''.
"""]},
    image = "topology.png"
  },

  ImageStep
  {
    header = HeaderPane {content = [Single """

## Your first topology

To start with, we will construct a simple topology comprising of two devices:
- a "Sampler" which produces "hello world" objects
- a "Sink" which consumes them

The source code for this example is at <https://github.com/FairRootGroup/FairRoot/tree/master/examples/MQ/1-sampler-sink>.

"""]},
    image = "sampler-sink.png"
  },

  SinglePaneStep
  {
    header = HeaderPane { content = [Single """

## Creating the package

In order to create our devices, lets first create a package where we put
all the required sources.

"""]},
    pane = ShellPane {content = [ Single """
$ cd O2
$ mkdir -p examples/tutorial-1
"""] }
  },

  TwoPanesStep
  {
    header = HeaderPane {content = [Single """

## The Sampler

We then create the Sampler. At minimum you will need to implement the
`Run()` method, which is used to implement the message handling loop of
the device.

"""]},
    leftPane = ShellPane {content = [Single """
$ cd O2
$ mkdir -p examples/tutorial-1
$ vim examples/tutorial-1/AliceO2TutorialSampler.h
"""]},
    rightPane = EditorPane { content = [Single """
#ifndef ALICEO2TUTORIALSAMPLER_H_
#define ALICEO2TUTORIALSAMPLER_H_

#include "FairMQDevice.h"

class AliceO2TutorialSampler : public FairMQDevice
{
  protected:
    virtual void Run();
};

#endif /* ALICEO2TUTORIALSAMPLER_H_ */
"""],
    filename = "examples/tutorial-1/AliceO2TutorialSampler.h"
    }
  },

  TwoPanesStep
  {
    header = HeaderPane {content = [Single """

## The Sampler

We now pass to the implementation of the `Run()` method.
""", Append """
First the `Run()` method we will actually make sure you will keep iterating
until the state machine does not exit from the `RUNNING` state.
""", ReplaceLast """
Inside this loop we construct a simple "Hello world" message which will
then published for subscribers to receive. Notice that by default the message will
be deallocated with `free()`. If you need to provide an customized destructor, you will need
to specify it as an argument of `CreateMessage()`.
""", ReplaceLastN 3 """

## The Sampler

The full code for our Sampler device is the following. Copy and paste
it in the correct place. Notice the use of the `LOG(INFO)` facility to
handle debug / informative messages and the fact that we artificially
limit the rate to one per second.
""", Append """
Once we have implemented the sampler class we need to actually create an 
executable which instanciates our device.
"""]},
    leftPane = ShellPane {
      content = [
        Single "
$ vim examples/tutorial-1/AliceO2TutorialSampler.cxx
"
        ]
   },
    rightPane = EditorPane {
      filename = "examples/tutorial-1/AliceO2TutorialSampler.cxx",
      content = [Single "", Single """ 
...

void AliceO2TutorialSampler::Run()
{
  while (CheckCurrentState(RUNNING))
  {
    ...
  }
}

...
""", Single """
...

char *text = strdup("Hello world");

std::unique_ptr<FairMQMessage> msg(NewMessage(text, strlen(text)));

Send(msg, "data");

...
""", Single """
#include <memory>

#include <boost/thread.hpp>

#include "AliceO2TutorialSampler.h"
#include "FairMQLogger.h"

void AliceO2TutorialSampler::Run()
{
  while (CheckCurrentState(RUNNING))
  {
    boost::this_thread::sleep(boost::posix_time::milliseconds(1000));

    char *text = strdup("Hello world");

    std::unique_ptr<FairMQMessage> msg(NewMessage(text, strlen(text)));

    LOG(INFO) << "Sending \\"" << text << "\\"";

    Send(msg, "data");
  }
}
"""]
    }
  },

  TwoPanesStep
  {
    header = HeaderPane { content = [Single """

## The Sink

Also for the Sink, we must derive from `FairMQDevice` and implement the
`Run()` method.

In this case the implementation will simply receive the messages and
print them out. This is done by invoking the `Receive()` method of the
channel.

""", Append """ The rest of the code is similar to the Sampler one, with 
the inner loop for the `RUNNING` state.

"""]},
    leftPane = EditorPane {
      filename = "examples/tutorial-1/AliceO2TutorialSink.h",
      content = [
        Single """
#ifndef ALICEO2TUTORIALSINK_H_
#define ALICEO2TUTORIALSINK_H_

#include "FairMQDevice.h"

class AliceO2TutorialSink : public FairMQDevice
{
  protected:
    virtual void Run();
};

#endif /* ALICEO2TUTORIALSINK_H_ */
"""]},
    rightPane = EditorPane {
      filename = "examples/tutorial-1/AliceO2TutorialSink.cxx",
      content = [Single """
...
unique_ptr<FairMQMessage> msg(NewMessage());

if (Receive(msg, "data") >= 0)
{
    LOG(INFO) << "Received message: \\""
              << string(static_cast<char*>(msg->GetData()),
                                           msg->GetSize())
              << "\\"";
}
...
""", Single """
#include "AliceO2TutorialSink.h"
#include "FairMQLogger.h"

using namespace std;

void AliceO2TutorialSink::Run()
{
    while (CheckCurrentState(RUNNING))
    {
        unique_ptr<FairMQMessage> msg(NewMessage());

        if (Receive(msg, "data") >= 0)
        {
            LOG(INFO) << "Received message: \\""
                      << string(static_cast<char*>(msg->GetData()),
                                                   msg->GetSize())
                      << "\\"";
        }
    }
}
"""]
    }
  },

  SinglePaneStep
  {
    header = HeaderPane { content = [Single """

## Creating the driver processes

Now that we have two classes for our own `FairMQDevice`s, we need to
create some boilerplate to be able to pass the (optional) arguments and
launch start the devices. We will call these two executable `runSampler`
and `runSink` respectively.

""", Replace """
## Creating the driver processes

First of all the driver is responsible to instanciate the devices and
the configuration option parser. We call the `CatchSignals()` method
of the `FairMQDevice` class to make sure that exceptions are properly
handled as `std::exceptions.`
""", ReplaceLast """
## Creating the driver processes

As part of the initialization the driver needs to:
- Parse the configuration.
""", Append """- Create the map of channel from the configuration.
""", Append """- Set the transport type and any other option found in the
configuration.
""", Append """- Initialise and transition the state machine until the
main loop is reached.
"""]},
    pane = EditorPane {
      filename = "examples/tutorial-1/runSampler.cxx",
      content = [ Single """
""", Single """
...
int main(int argc, char** argv)
{
  AliceO2TutorialSampler sampler;
  sampler.CatchSignals();

  FairMQProgOptions config;

  try
  {
    if (config.ParseAll(argc, argv))
      return 0;
    ...
  }
  catch (std::exception& e)
  {
    LOG(ERROR) << e.what();
    LOG(INFO) << "Command line options are the following: ";
    config.PrintHelp();
    return 1;
  }
  return 0;
}
""", Single """ 
...

std::string filename = config.GetValue<std::string>("config-json-file");
std::string id = config.GetValue<std::string>("id");

config.UserParser<FairMQParser::JSON>(filename, id);
""", Append """
sampler.fChannels = config.GetFairMQMap();
""", Append """
sampler.SetTransport(config.GetValue<std::string>("transport"));
sampler.SetProperty(AliceO2TutorialSampler::Id, id);
""", Append """
sampler.ChangeState("INIT_DEVICE");
sampler.WaitForEndOfState("INIT_DEVICE");

sampler.ChangeState("INIT_TASK");
sampler.WaitForEndOfState("INIT_TASK");

sampler.ChangeState("RUN");
sampler.InteractiveStateLoop();
"""]}
  },

  TwoPanesStep {
  header = HeaderPane {content = [Single """
  ## Creating the driver processes

  The final sourcecode for the sampler can be found below with the similar one for the sink.
  """]} ,
  leftPane = EditorPane {
    filename = "examples/tutorial-1/runSampler.cxx",
    content = [Single """
#include <iostream>

#include "boost/program_options.hpp"

#include "FairMQLogger.h"
#include "FairMQParser.h"
#include "FairMQProgOptions.h"
#include "AliceO2TutorialSampler.h"

using namespace boost::program_options;

int main(int argc, char** argv)
{
    AliceO2TutorialSampler sampler;
    sampler.CatchSignals();

    FairMQProgOptions config;

    try
    {
        if (config.ParseAll(argc, argv))
        {
            return 0;
        }

        std::string filename = config.GetValue<std::string>("config-json-file");
        std::string id = config.GetValue<std::string>("id");

        config.UserParser<FairMQParser::JSON>(filename, id);

        sampler.fChannels = config.GetFairMQMap();

        LOG(INFO) << "PID: " << getpid();

        sampler.SetTransport(config.GetValue<std::string>("transport"));

        sampler.SetProperty(AliceO2TutorialSampler::Id, id);

        sampler.ChangeState("INIT_DEVICE");
        sampler.WaitForEndOfState("INIT_DEVICE");

        sampler.ChangeState("INIT_TASK");
        sampler.WaitForEndOfState("INIT_TASK");

        sampler.ChangeState("RUN");
        sampler.InteractiveStateLoop();
    }
    catch (std::exception& e)
    {
        LOG(ERROR) << e.what();
        LOG(INFO) << "Command line options are the following: ";
        config.PrintHelp();
        return 1;
    }

    return 0;
}
"""] },
    rightPane = EditorPane {
      filename = "examples/tutorial-1/runSink.cxx",
      content = [ Single """
#include <iostream>

#include "FairMQLogger.h"
#include "FairMQParser.h"
#include "FairMQProgOptions.h"
#include "AliceO2TutorialSink.h"

int main(int argc, char** argv)
{
    AliceO2TutorialSink sink;
    sink.CatchSignals();

    FairMQProgOptions config;

    try
    {
        if (config.ParseAll(argc, argv))
        {
            return 0;
        }

        std::string filename = config.GetValue<std::string>("config-json-file");
        std::string id = config.GetValue<std::string>("id");

        config.UserParser<FairMQParser::JSON>(filename, id);

        sink.fChannels = config.GetFairMQMap();

        LOG(INFO) << "PID: " << getpid();

        sink.SetTransport(config.GetValue<std::string>("transport"));

        sink.SetProperty(AliceO2TutorialSink::Id, id);

        sink.ChangeState("INIT_DEVICE");
        sink.WaitForEndOfState("INIT_DEVICE");

        sink.ChangeState("INIT_TASK");
        sink.WaitForEndOfState("INIT_TASK");

        sink.ChangeState("RUN");
        sink.InteractiveStateLoop();
    }
    catch (std::exception& e)
    {
        LOG(ERROR) << e.what();
        LOG(INFO) << "Command line options are the following: ";
        config.PrintHelp();
        return 1;
    }

    return 0;
}
"""]
    }
  },

  TwoPanesStep {
    header = HeaderPane { content = [Single """## Compiling

In order to compile in Alice O2 we rely on [CMake](https://cmake.org). You will need
to add a `examples/tutorial-1/CMakeLists.txt` which specifies how to compile the to Device
driver processes.
""", Append """In order to build you need to move to the
`sw/BUILD/O2-latest/O2` directory and type make.
"""]},
    leftPane = ShellPane { 
      content = [Single """
$ vim examples/tutorial-1/CMakeLists.txt
""",Append """
$ cd sw/BUILD/O2-latest/O2
$ make -j 10 install
...
[ 73%] Built target aliceHLTEventSampler
[ 74%] Built target aliceHLTWrapper
[ 76%] Built target runComponent
[ 88%] Built target AliceO2Cdb
[ 90%] Built target conditions-client
[ 91%] Built target conditions-server
[ 91%] Built target libAliceO2Cdb.rootmap
[ 94%] Built target runSampler
[ 96%] Built target runSink
[ 97%] Built target libtestits.rootmap
[100%] Built target testits
$ 
""", Replace """
$ which runSampler 
/Users/me/alice/sw/osx_x86-64/O2/master-1/bin/runSampler
$ which runSink
/Users/me/alice/sw/osx_x86-64/O2/master-1/bin/runSink
"""],
    },
    rightPane = EditorPane { 
      filename = "examples/tutorial-1/CMakeLists.txt",
      content = [Single """
include_directories(
  ${FAIRROOT_ROOT}/include
  ${Boost_INCLUDE_DIR}
  ${FAIRROOT_INCLUDE_DIR} 
  ${CMAKE_SOURCE_DIR}/examples/tutorial-1
)

link_directories(
  ${Boost_LIBRARY_DIRS}
  ${FAIRROOT_LIBRARY_DIR} 
)

add_executable(runSink runSink.cxx AliceO2TutorialSink.cxx)
target_link_libraries(runSink FairMQ 
                              boost_log
                              boost_thread
                              boost_system
                              boost_program_options
                              fairmq_logger)
add_executable(runSampler runSampler.cxx AliceO2TutorialSampler.cxx)
target_link_libraries(runSampler FairMQ 
                                 boost_log
                                 boost_thread
                                 boost_system
                                 boost_program_options
                                 fairmq_logger)
install(TARGETS runSampler runSink
        RUNTIME DESTINATION bin)
"""]
    }
  },

  TwoPanesStep {
    header = HeaderPane { content = [Single """## Configuration 

Now that we have two devices, we need run them and make sure they are   
configured correctly so that they can talk to each other. This is done via a
JSON based configuration.
""", Replace """## Configuration
At the toplevel the configuration has the following structure, 
where there is one `device` stanza for each device we want to run (two
in our case, one for the sampler and one for the sink).
""", Replace """## Configuration
At minimum, each of the stanzas will have to specify a unique id for the
device and the details about its channels, making sure they correspond
to what is being specified in the C++ code.
"""]},
    leftPane = ShellPane { 
      content = [Single """
$ vim examples/tutorial-1/config.json
"""],
    },
    rightPane = EditorPane {
      filename = "examples/tutorial-1/config.json",
      content = [Single "", Single """
{
  "fairMQOptions":
  {
    "device":
    {
      ...
    },
    "device":
    {
      ...
    }
  }
}
""", Replace """
"id": "sampler1",
"channel":
{
    "name": "data",
    "socket":
    {
        "type": "push",
        "method": "bind",
        "address": "tcp://*:5555",
        "sndBufSize": "1000",
        "rcvBufSize": "1000",
        "rateLogging": "0"
    }
}
""", Single """
{
    "fairMQOptions":
    {
        "device":
        {
            "id": "sampler1",
            "channel":
            {
                "name": "data",
                "socket":
                {
                    "type": "push",
                    "method": "bind",
                    "address": "tcp://*:5555",
                    "sndBufSize": "1000",
                    "rcvBufSize": "1000",
                    "rateLogging": "0"
                }
            }
        },

        "device":
        {
            "id": "sink1",
            "channel":
            {
                "name": "data",
                "socket":
                {
                    "type": "pull",
                    "method": "connect",
                    "address": "tcp://localhost:5555",
                    "sndBufSize": "1000",
                    "rcvBufSize": "1000",
                    "rateLogging": "0"
                }
            }
        }
    }
}
"""]
    }
  },

  TwoPanesStep {
      header = HeaderPane { content = [Single """
## Running 

We can finally run our applications. Simply pass the configuration when
invoking them on the command line.
""", Append """Notice how we also need to provide the id of the device on the command 
line so that it's configuration can be picked up from file."""]},
      leftPane = ShellPane { 
        content = [
      Single """
$ runSampler --id sampler1 \\
             --config-json-file examples/tutorial-1/config.json
      """,
      Reuse,
      Append """
[STATE] Entering FairMQ state machine
[INFO] *************************************************************************************
[INFO] ***************************     Program options found     ***************************
[INFO] *************************************************************************************
[INFO] config-json-file = examples/tutorial-1/config.json  [Type=string]  [provided value] *
[INFO] id               = sampler1                         [Type=string]  [provided value] *
[INFO] io-threads       = 1                                [Type=int]     [default value]  *
[INFO] log-color        = 1                                [Type=bool]    [default value]  *
[INFO] transport        = zeromq                           [Type=string]  [default value]  *
[INFO] verbose          = DEBUG                            [Type=string]  [default value]  *
[INFO] *************************************************************************************
[DEBUG] Found device id 'sampler1' in JSON input
[DEBUG] Found device id 'sink1' in JSON input
[DEBUG] [node = device]   id = sampler1
[DEBUG]        [node = channel]   name = data
[DEBUG]                [node = socket]   socket index = 1
[DEBUG]                        type        = push
[DEBUG]                        method      = bind
[DEBUG]                        address     = tcp://*:5555
[DEBUG]                        sndBufSize  = 1000
[DEBUG]                        rcvBufSize  = 1000
[DEBUG]                        rateLogging = 0
[DEBUG] ---- Channel-keys found are :
[DEBUG] data
[INFO] PID: 41567
[DEBUG] Using ZeroMQ library, version: 4.1.3
[STATE] Entering INITIALIZING DEVICE state
[DEBUG] Validating channel "data[0]"... VALID
[DEBUG] Initializing channel data[0] (push)
[DEBUG] Binding channel data[0] on tcp://*:5555
[STATE] Entering DEVICE READY state
[STATE] Entering INITIALIZING TASK state
[STATE] Entering READY state
[STATE] Entering RUNNING state
[INFO] DEVICE: Running...
[INFO] Use keys to control the state machine:
[INFO] [h] help, [p] pause, [r] run, [s] stop, [t] reset task, [d] reset device, [q] end, [j] init task, [i] init device
""", ReplaceLast """
...
[INFO] Sending "Hello world"
"""]
    },
      rightPane = ShellPane {
        content = [Single """
$ runSink --id sink1 \\
          --config-json-file examples/tutorial-1/config.json
""",
    Reuse, 
    Append """
[STATE] Entering FairMQ state machine                                                        [250/371]
[INFO] *************************************************************************************
[INFO] ***************************     Program options found     ***************************
[INFO] *************************************************************************************
[INFO] config-json-file = examples/tutorial-1/config.json  [Type=string]  [provided value] *
[INFO] id               = sink1                            [Type=string]  [provided value] *
[INFO] io-threads       = 1                                [Type=int]     [default value]  *
[INFO] log-color        = 1                                [Type=bool]    [default value]  *
[INFO] transport        = zeromq                           [Type=string]  [default value]  *
[INFO] verbose          = DEBUG                            [Type=string]  [default value]  *
[INFO] *************************************************************************************
[DEBUG] Found device id 'sampler1' in JSON input
[DEBUG] Found device id 'sink1' in JSON input
[DEBUG] [node = device]   id = sink1
[DEBUG]        [node = channel]   name = data
[DEBUG]                [node = socket]   socket index = 1
[DEBUG]                        type        = pull
[DEBUG]                        method      = connect
[DEBUG]                        address     = tcp://localhost:5555
[DEBUG]                        sndBufSize  = 1000
[DEBUG]                        rcvBufSize  = 1000
[DEBUG]                        rateLogging = 0
[DEBUG] ---- Channel-keys found are :
[DEBUG] data
[INFO] PID: 56198
[DEBUG] Using ZeroMQ library, version: 4.1.3
[STATE] Entering INITIALIZING DEVICE state
[DEBUG] Validating channel "data[0]"... VALID
[DEBUG] Initializing channel data[0] (pull)
[DEBUG] Connecting channel data[0] to tcp://localhost:5555
[STATE] Entering DEVICE READY state
[STATE] Entering INITIALIZING TASK state
[STATE] Entering READY state
[STATE] Entering RUNNING state
[INFO] DEVICE: Running...
[INFO] Use keys to control the state machine:
[INFO] [h] help, [p] pause, [r] run, [s] stop, [t] reset task, [d] reset device, [q] end, [j] init task, [i] init device
""", ReplaceLast """
...
[INFO] Received message "Hello world"
"""]
    }
  },
  SinglePaneStep {
    header = HeaderPane { content = [ Single """ ## Using DDS (Incomplete)
Using the configuration file and mapping different ports
and applications can become complex, especially if you
plan to run your software in a distributed manner, on a
cluster. In order to help to these kind of issues the [DDS
project](http://dds.gsi.de/doc/nightly/quick-start.html) provides an
easy way to do deployments which range from a single host to a whole
cluster.
    """, Replace """ ## Using DDS (Incomplete)
First of all make sure DDS is available in your installation.
""", 
  Append """
Then we can start the DDS commander via `dds-server` which will
take care managing your topology.
  """,
  Append """
You can then start the agent using `dds-submit`.
""",
  Append """
You can check how many agents you have available by running `dds-info -n` and 
`dds-info -l`.
"""
  ]},
    pane = ShellPane { content = [
             Single """
""", 
             Single """
$ pushd $DDS_ROOT ; source DDS_env.sh ; popd
$ which dds-server 

/Users/me/alice/sw/osx_x86-64/DDS/master-1/bin/dds-server
""", 
              Append """
$ dds-server start -s
Checking availability of WN bin of the local system...
found compatible WN bin: dds-wrk-bin-1.1.21.g93c122a-Darwin-universal.tar.gz
Starting DDS commander...
------------------------
DDS commander server: 18733
------------------------
""",
              Append """
$ dds-submit --rms ssh -n 1
""",
              Append """
$ dds-info -n
$ dds-info -l
""",
              Append """
$ dds-topology --set $DDS_ROOT/tutorials/tutorial1/tutorial1_topo.xml
""",
              Append """
$ dds-topology --activate
"""
 ]}
  },

  SinglePaneStep {
      header = HeaderPane { content = [Single """## Final words
In this tutorial we have seens how to setup your work environment,
how to create a couple of FairRoot devices and run them both standalone
and (soon) using DDS. You are now encouraged to look at the other FairRoot
tutorials:

<https://github.com/FairRootGroup/FairRoot/tree/master/examples>

"""]},
      pane = ShellPane { 
        content = [Single """
  """],
    }
  }
  ]
