# holochain_logging


[![Project](https://img.shields.io/badge/project-holochain-blue.svg?style=flat-square)](http://holochain.org/)
[![Chat](https://img.shields.io/badge/chat-chat%2eholochain%2enet-blue.svg?style=flat-square)](https://chat.holochain.net)

[![Twitter Follow](https://img.shields.io/twitter/follow/holochain.svg?style=social&label=Follow)](https://twitter.com/holochain)

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

## Overview

# Logging

This logger implementation has been designed to be fast. It delegates most of the heavy work to a dedicated thread. It offers nice filtering capability that can be combined with an optional and easy to use [TOML](https://github.com/toml-lang/toml) configuration.

## Examples

To have a generale view of the capability of this crate, you can run this command:

```bash
cargo run --example simple-fastlog-example
```

or

```bash
cargo run --example from-toml-fastlog-example
```

Additional examples can be found [here](./examples) as well.

## CLI Support

This logging factory handles the environnement variable **RUST_LOG** as well so it can be used like this (the logger has to be registered):

```bash
RUST_LOG="debug" path/to/exec
```

## Building a logger

Here is an example of how to simply build a logger with the [`Debug`](https://docs.rs/log/0.4.8/log/enum.Level.html#variant.Debug) log verbosity level:

```rust
FastLoggerBuilder::new()
    // Optionally you can specify your custom timestamp format
    .timestamp_format("%Y-%m-%d %H:%M:%S%.6f")
    .set_level_from_str("Debug")
    .build()
    .expect("Fail to init the logging factory.");

debug!("What's bugging you today?");
```
## Filtering

Filtering out every log from dependencies and putting back in everything related to a particular [`target`](https://docs.rs/log/0.4.8/log/struct.Record.html#method.target) is easy:

```rust
let toml = r#"
[logger]
level = "debug"

[[logger.rules]]
pattern = ".*"
exclude = true

[[logger.rules]]
pattern = "^holochain"
exclude = false
"#;

FastLoggerBuilder::from_toml(toml)
.expect("Fail to instantiate the logger from toml.")
.build()
.expect("Fail to build logger from toml.");

// Should NOT be logged
debug!(target: "rpc", "This is our dependency log filtering.");

// Should be logged each in different color. We avoid filtering by prefixing using the 'target'
// argument.
info!(target: "holochain", "Log message from Holochain Core.");
info!(target: "holochain-app-2", "Log message from Holochain Core with instance ID 2");
```


## License
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

Copyright (C) 2019, Holochain Foundation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
