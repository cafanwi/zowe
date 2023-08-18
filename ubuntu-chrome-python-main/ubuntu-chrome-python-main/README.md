curl http://hostname:8080

lynx http://localhost:8080

```
python3 --version
gradle --version
python3 -c "import selenium; print(selenium.__version__)"
java --version
```


Troubleshoot network

```
netstat -tuln | grep 8080
netstat -tuln | grep 80 

ss -tuln
ss -tuln | grep 80
ss -tuln | grep 8080
```
