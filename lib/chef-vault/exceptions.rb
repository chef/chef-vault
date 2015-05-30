# Author:: Kevin Moser <kevin.moser@nordstrom.com>
# Copyright:: Copyright 2013-15, Nordstrom, Inc.
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

class ChefVault
  class Exceptions < RuntimeError
    class SecretDecryption < Exceptions
    end

    class NoKeysDefined < Exceptions
    end

    class ItemNotEncrypted < Exceptions
    end

    class KeysActionNotValue < Exceptions
    end

    class AdminNotFound < Exceptions
    end

    class ClientNotFound < Exceptions
    end

    class KeysNotFound < Exceptions
    end

    class ItemNotFound < Exceptions
    end

    class ItemAlreadyExists < Exceptions
    end

    class SearchNotFound < Exceptions
    end

    class IdMismatch < Exceptions
    end

    class V1Format < Exceptions
    end
  end
end
