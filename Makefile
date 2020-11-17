install: check-tree clean in out
	chmod +x ./install-unpriv.sh
	chmod +x ./install-priv.sh
	./install-unpriv.sh $(TREE)
	sudo ./install-priv.sh $(TREE)

in:
	g++ mail_in.cpp -o mail-in

out:
	g++ mail_out.cpp -o mail-out

clean:
	rm -f mail-in mail-out || true
	
check-tree:
	@[ "${TREE}" ] && echo "TREE is ${TREE}" || ( echo "TREE is not set!"; exit 1 )