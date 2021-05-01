
INSTALLER_URL = https://www.onsemi.com/pub/collateral/lc87series_tool_installer.zip

.PHONY: clean toolchain example
CACHE_DIR = cache
TOOLCHAIN_DIR = lc87-toolchain

toolchain: $(TOOLCHAIN_DIR)

example: toolchain
	$(MAKE) -C ./example/

$(CACHE_DIR):
	mkdir -p ./$@

clean:
	@rm -Rf ./$(CACHE_DIR)
	
$(CACHE_DIR)/installer.zip: | cache
	wget -O $@ "$(INSTALLER_URL)"
	
$(CACHE_DIR)/Setup_Lc87Tools_310.exe: $(CACHE_DIR)/installer.zip
	unzip -u $< -d $(CACHE_DIR)
	touch $@

$(CACHE_DIR)/SourceFiles $(CACHE_DIR)/code$$GetTrialDir$$v3.2r2: $(CACHE_DIR)/Setup_Lc87Tools_310.exe
	innoextract -d $(CACHE_DIR) -I /tmp -I '/code$$GetTrialDir$$v3.2r2' $<
	unshield -d $(CACHE_DIR) -g SourceFiles x $(CACHE_DIR)/tmp/Disk1/data1.cab

$(TOOLCHAIN_DIR): $(CACHE_DIR)/SourceFiles $(CACHE_DIR)/code$$GetTrialDir$$v3.2r2 | $(CACHE_DIR)
	rm -Rf $(CACHE_DIR)/toolchain
	mkdir -p $(CACHE_DIR)/toolchain
	
	rsync -a '$(CACHE_DIR)/code$$GetTrialDir$$v3.2r2/bin' $(CACHE_DIR)/toolchain
	rsync -a '$(CACHE_DIR)/code$$GetTrialDir$$v3.2r2/include' $(CACHE_DIR)/toolchain
	rsync -a '$(CACHE_DIR)/code$$GetTrialDir$$v3.2r2/include.lsl' $(CACHE_DIR)/toolchain
	
	#to lowercase
	for i in $$( ls '$(CACHE_DIR)/toolchain/include' ); do new="$$( echo $$i | tr 'A-Z' 'a-z' )"; if [ "$$new" != "$$i" ]; then mv '$(CACHE_DIR)/toolchain/include/'"$$i" '$(CACHE_DIR)/toolchain/include/'"$$new"; fi; done
	for i in $$( ls '$(CACHE_DIR)/toolchain/include.lsl' ); do new="$$( echo $$i | tr 'A-Z' 'a-z' )"; if [ "$$new" != "$$i" ]; then mv '$(CACHE_DIR)/toolchain/include.lsl/'"$$i" '$(CACHE_DIR)/toolchain/'"$$new"; fi; done
	
	cp $(CACHE_DIR)/SourceFiles/bin/as87.exe $(CACHE_DIR)/toolchain/bin
	cp $(CACHE_DIR)/SourceFiles/bin/c87.exe $(CACHE_DIR)/toolchain/bin
	cp $(CACHE_DIR)/SourceFiles/bin/cc87.exe $(CACHE_DIR)/toolchain/bin
	cp $(CACHE_DIR)/SourceFiles/bin/l87.exe $(CACHE_DIR)/toolchain/bin
	
	mkdir -p $(CACHE_DIR)/toolchain/doc/pdf
	cp $(CACHE_DIR)/SourceFiles/doc/pdf/m_c87.pdf $(CACHE_DIR)/toolchain/doc/pdf
	cp $(CACHE_DIR)/SourceFiles/doc/pdf/m_as87.pdf $(CACHE_DIR)/toolchain/doc/pdf
	
	rsync -a $(CACHE_DIR)/SourceFiles/lib $(CACHE_DIR)/toolchain
	rsync -a $(CACHE_DIR)/SourceFiles/include $(CACHE_DIR)/toolchain
	rsync -a $(CACHE_DIR)/SourceFiles/include.lsl $(CACHE_DIR)/toolchain
	
	cp -r src/script $(CACHE_DIR)/toolchain/
	
	chmod +x $(CACHE_DIR)/toolchain/bin/*
	chmod +x $(CACHE_DIR)/toolchain/script/*
	
	rm -Rf ./$@
	mv $(CACHE_DIR)/toolchain $@

