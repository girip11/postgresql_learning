# Using the Vagrant VM

* `vagrant up` - creates and provisions the VM. As part of VM provisioning, postgresql is installed.

* `vagrant ssh` - to SSH in to the VM and execute the **install_pgadmin4.sh** and provides the **email and password**

* With pgadmin4 installed, we can load the url `http://ip/pgadmin4` in the browser and create a server pointing the postgresql installed within the VM.

* Extract **dvdrental.zip** and we will get **dvdrental.tar**.

```bash
cd /vagrant

# Install unzip if not already installed
sudo apt install -y unzip

unzip dvdrental.zip
```

* Create a database called **dvdrental**

* [Restore the database](http://www.postgresqltutorial.com/load-postgresql-sample-database/) from **dvdrental.tar** to postgresql using the **pg_restore** command.

```bash
cd /vagrant

# Inside the VM
# Use the -W flag to prompt for password, since we have disabled peer auth while provisioning
pg_restore -h localhost -U postgres -d dvdrental -W ./dvdrental.tar
```

* Verify the import using pgadmin4 UI.

---

## References

* [dvdrental database from postgresqltutorial.com](http://www.postgresqltutorial.com/postgresql-sample-database/)
