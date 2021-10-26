<img src="https://user-images.githubusercontent.com/59084371/122537541-3df38100-d058-11eb-8d68-503a0caa35af.PNG" width="100">

# Silicoin Docker Container
https://www.silicoin.cc/

## Configuration
Required configuration:
* Publish network port via `-p 10444:10444`
* Bind mounting a host plot dir in the container to `/plots`  (e.g. `-v /path/to/hdd/storage/:/plots`)
* Bind mounting a host config dir in the container to `/root/.sit`  (e.g. `-v /path/to/storage/:/root/.sit`)
* Bind mounting a host config dir in the container to `/root/.sit_keys`  (e.g. `-v /path/to/storage/:/root/.sit_keys`)
* Set initial `sit keys add` method:
  * Manual input from docker shell via `-e KEYS=type` (recommended)
  * Copy from existing farmer via `-e KEYS=copy` and `-e CA=/path/to/mainnet/config/ssl/ca/` 
  * Add key from mnemonic text file via `-e KEYS=/path/to/mnemonic.txt`
  * Generate new keys (default)

Optional configuration:
* Pass multiple plot directories via PATH-style colon-separated directories (.e.g. `-e plots_dir=/plots/01:/plots/02:/plots/03`)
* Set desired time zone via environment (e.g. `-e TZ=Europe/Berlin`)

On first start with recommended `-e KEYS=type`:
* Open docker shell `docker exec -it <containerid> sh`
* Enter `sit keys add`
* Paste space-separated mnemonic words
* Restart docker cotainer
* Enter `sit wallet show`
* Press `S` to skip restore from backup

## Operation
* Open docker shell `docker exec -it <containerid> sh`
* Check synchronization `sit show -s -c`
* Check farming `sit farm summary`
* Check balance `sit wallet show`
* 
