# Author:: Kevin Moser <kevin.moser@nordstrom.com>
# Copyright:: Copyright 2013, Nordstrom, Inc.
# License:: Apache License, Version 2.0

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class ChefVault::Exceptions
  class AdminDeauthorization < RuntimeError; end
  class AdminNotFound < RuntimeError; end
  class ClientNotFound < RuntimeError; end
  class ItemAlreadyExists < RuntimeError; end
  class ItemNotEncrypted < RuntimeError; end
  class ItemNotFound < RuntimeError; end
  class KeysActionNotValue < RuntimeError; end
  class KeysNotFound < RuntimeError; end
  class NoKeysDefined < RuntimeError; end
  class SecretDecryption < RuntimeError; end
end
