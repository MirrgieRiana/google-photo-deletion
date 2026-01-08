TAKEOUT_ZIP = \
	takeout-20251205T045917Z-001.zip \
	takeout-20251205T045917Z-3-001.zip \
	takeout-20251205T045917Z-3-002.zip \
	takeout-20251205T045917Z-3-003.zip \
	takeout-20251205T045917Z-3-004.zip \
	takeout-20251205T045917Z-3-005.zip \
	takeout-20251205T045917Z-3-006.zip \
	takeout-20251205T045917Z-3-007.zip \
	takeout-20251205T045917Z-3-008.zip \
	takeout-20251205T045917Z-3-009.zip \
	takeout-20251205T045917Z-3-010.zip
TAKEOUT_MD5S = $(TAKEOUT_ZIP:.zip=.md5s)
MD5S = $(TAKEOUT_MD5S) takeout.md5s archive.md5s taihi.md5s
TAKEOUT_JSONS = $(TAKEOUT_MD5S:%=%.jsons)
JSONS = $(MD5S:%=%.jsons)

.PHONY: all
all: $(JSONS)

.PHONY: clean
clean:
	rm takeout.md5s $(JSONS)

takeout.md5s: $(TAKEOUT_MD5S)
	cat $(TAKEOUT_MD5S) > $@

%.md5s.jsons: %.md5s md5s_to_jsons
	cat $< | ./md5s_to_jsons > $@

.PHONY: get_all_md5s
get_all_md5s:
	./get_md5s "/mnt/t/Dropbox/カメラアップロード/アーカイブ" | tee archive.md5s
	./get_md5s "/mnt/t/Dropbox/カメラアップロード/退避" | tee taihi.md5s
	./get_md5s "/mnt/t/20251208_google-photo-deletion/takeout-20251205T045917Z-001" | tee "takeout-20251205T045917Z-001.md5s"
	./get_md5s "/mnt/t/20251208_google-photo-deletion/takeout-20251205T045917Z-3-001" | tee "takeout-20251205T045917Z-3-001.md5s"
	./get_md5s "/mnt/t/20251208_google-photo-deletion/takeout-20251205T045917Z-3-002" | tee "takeout-20251205T045917Z-3-002.md5s"
	./get_md5s "/mnt/t/20251208_google-photo-deletion/takeout-20251205T045917Z-3-003" | tee "takeout-20251205T045917Z-3-003.md5s"
	./get_md5s "/mnt/t/20251208_google-photo-deletion/takeout-20251205T045917Z-3-004" | tee "takeout-20251205T045917Z-3-004.md5s"
	./get_md5s "/mnt/t/20251208_google-photo-deletion/takeout-20251205T045917Z-3-005" | tee "takeout-20251205T045917Z-3-005.md5s"
	./get_md5s "/mnt/t/20251208_google-photo-deletion/takeout-20251205T045917Z-3-006" | tee "takeout-20251205T045917Z-3-006.md5s"
	./get_md5s "/mnt/t/20251208_google-photo-deletion/takeout-20251205T045917Z-3-007" | tee "takeout-20251205T045917Z-3-007.md5s"
	./get_md5s "/mnt/t/20251208_google-photo-deletion/takeout-20251205T045917Z-3-008" | tee "takeout-20251205T045917Z-3-008.md5s"
	./get_md5s "/mnt/t/20251208_google-photo-deletion/takeout-20251205T045917Z-3-009" | tee "takeout-20251205T045917Z-3-009.md5s"
	./get_md5s "/mnt/t/20251208_google-photo-deletion/takeout-20251205T045917Z-3-010" | tee "takeout-20251205T045917Z-3-010.md5s"

.PHONY: delete_extra_files
delete_extra_files:
	for f in $(TAKEOUT_ZIP:.zip=); do ./delete_extra_files $$f; done

.PHONY: delete_if_match
delete_if_match: $(JSONS)
	./match takeout.md5s.jsons archive.md5s.jsons | bash
	./match takeout.md5s.jsons taihi.md5s.jsons | bash

.PHONY: delete_if_same_image_hash
delete_if_same_image_hash: takeout.md5s.jsons match_by_image_hash
	cat takeout.md5s.jsons | ./match_by_image_hash | bash
