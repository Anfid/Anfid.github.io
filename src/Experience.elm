module Experience exposing (..)

import Date exposing (Date)
import Time exposing (Month(..))


type alias EmploymentEntry =
    { role : String
    , company : String
    , start : Date
    , end : Maybe Date
    , location : String
    , skills : List String
    , description : List (List String)
    }


type alias EducationEntry =
    { institution : String
    , location : String
    , start : Date
    , end : Maybe Date
    }


about : List (List String)
about =
    [ [ "I'm a Rust engineer experienced in Rust, WebAssembly, UNIX and blockchain. My C/C++ embedded background "
      , "provided me with deep understanding of how software works on the lowest level and how it interacts with "
      , "hardware. During software development my main priority is it's reliability and security. I put in extra "
      , "effort to make sure that it adheres to best practices and applicable open standards."
      ]
    , [ "I have experience in coordinating teamwork on a project and prioritizing key features and tasks. I "
      , "proactively engage in discussions of what project or feature aims to achieve and what is required to "
      , "implement it. This allows me to identify potential difficult points early on, provide swift feedback and set "
      , "realistic goals or come up with a good compromise if resources are limited."
      ]
    , [ "And of course I always remain open to learning from other people or from my own experiences. I feel like this "
      , "is a must for being a good developer in a rapidly-changing software development world."
      ]
    ]


employmentList : List EmploymentEntry
employmentList =
    [ { role = "Embedded developer (C/C++)"
      , company = "MERA"
      , start = Date.fromCalendarDate 2018 Mar 1
      , end = Just <| Date.fromCalendarDate 2019 Sep 1
      , location = "Nizhniy Novgorod, Russia"
      , skills = [ "C/C++", "Embedded", "Networking", "Buildroot", "RTOS" ]
      , description =
            [ [ "Developed and maintained fire alarm and security systems on embedded devices running Linux and TreadX RTOS."
              ]
            , [ "Improved device network connection stability."
              ]
            , [ "Migrated legacy firmware to a device running RTOS."
              ]
            , [ "Researched networking standards and protocols to work on network switch firmware."
              ]
            ]
      }
    , { role = "Blockchain developer (Rust)"
      , company = "XDSoft"
      , start = Date.fromCalendarDate 2019 Sep 1
      , end = Just <| Date.fromCalendarDate 2021 Mar 1
      , location = "Novosibirsk, Russia"
      , skills = [ "Rust", "Tokio", "GitLab CI", "Exonum" ]
      , description =
            [ [ "Implemented the intellectual property tracking system on top of the Exonum blockchain node."
              ]
            , [ "Updated consensus algorithm to improve node connectivity."
              ]
            , [ "Had to take over leading the project development urgently, was able to adapt to new responsibilities quickly and made "
              , "sure that good quality product was delivered in time."
              ]
            , [ "Integrated cryptography library in accordance with certification requirements, provided necessary documentation for "
              , "certification process."
              ]
            , [ "Set up and optimized GitLab CI test and build process for Rust project."
              ]
            ]
      }
    , { role = "Blockchain developer (Rust)"
      , company = "Gear"
      , start = Date.fromCalendarDate 2021 Aug 1
      , end = Just <| Date.fromCalendarDate 2021 Dec 1
      , location = "Moscow, Russia"
      , skills = [ "Rust", "WebAssembly", "Substrate", "API design" ]
      , description =
            [ [ "Provided library interface for smart contract development with safe and user-friendly abstractions over low-level functions "
              , "exposed by smart contract platform."
              ]
            , [ "Greatly extended the functionality of smart contract test library and streamlined it's API."
              ]
            , [ "Implemented unit tests for existing functionality."
              ]
            ]
      }
    , { role = "Smart contract developer (Rust)"
      , company = "Bictory"
      , start = Date.fromCalendarDate 2022 Jan 1
      , end = Just <| Date.fromCalendarDate 2022 Oct 1
      , location = "Remote"
      , skills = [ "Rust", "Smart Contracts", "WebAssembly", "Concordium", "API design" ]
      , description =
            [ [ "Updated NFT project to adhere to Concordium blockchain interoperability standard CIS-1."
              ]
            , [ "Took full responsibility for designing and implementing name service smart contract for Concordium ecosystem and "
              , "provided a flexible solution within strict time schedule despite unclear and fluctuating requirements. During my work "
              , "on the name service I was able to provide stable documentation of future API and binary serialization format extremely "
              , "early to allow the start of integration process and reduce overall project development time."
              ]
            , [ "All the work had to be done in a rapidly changing environment, some work-in-progress solutions had to be reworked "
              , "swiftly due to blockchain updates."
              ]
            , [ "Aggressively optimized WebAssembly binaries for size to provide extensive functionality despite strict blockchain limitations."
              ]
            ]
      }
    , { role = "Blockchain developer (Rust) and founding engineer"
      , company = "TONOMUS, NEOM"
      , start = Date.fromCalendarDate 2023 Oct 1
      , end = Just <| Date.fromCalendarDate 2024 Mar 7
      , location = "Remote"
      , skills = [ "Rust", "Substrate", "DID" ]
      , description =
            [ [ "Developed and maintained a decentralized identity system based on the Substrate framework."
              ]
            , [ "Added support for flexible Substrate runtime configurations for development, staging and production "
              , "environments."
              ]
            , [ "Researched try-runtime feature of Substrate, implemented it in the project and gave an internal "
              , "presentation, summarizing its features and use cases to the dev team."
              ]
            , [ "Conducted research for a startup at an extremely early stage."
              ]
            , [ "Led efforts to organize research data. Analyzed it, proposed new ideas shaping early versions of the "
              , "product."
              ]
            , [ "Designed early product prototypes in Figma to collect user feedback."
              ]
            ]
      }
    ]


educationList : List EducationEntry
educationList =
    [ { institution = "Nizhniy Novgorod Technical College"
      , location = "Nizhniy Novgorod, Russia"
      , start = Date.fromCalendarDate 2013 Oct 1
      , end = Just <| Date.fromCalendarDate 2017 Oct 1
      }
    ]
