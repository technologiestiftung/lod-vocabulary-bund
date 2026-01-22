
generate: data/temp/all.nt
	python bin/generate.py

generate+serve_locally: data/temp/all.nt
	python bin/generate.py --site_url http://localhost:8000 --serve

data/bundorgs/stats.ttl: data/bundorgs/bundorgs.ttl
	@echo "generating VOID statistics for Bundorgs vocab from $^..."
	@echo "writing to $@ ..."
	@python bin/void_statistics.py \
		--input $^ \
		--base_uri "https://technologiestiftung.github.io/lod-vocabulary-bund/bundorgs/" \
		--base_prefix "bundorgs" \
		--dataset_uri "https://technologiestiftung.github.io/lod-vocabulary-bund/bundorgs/" > $@

# This target creates the RDF file that serves as the input to the static site generator.
# All data should be merged in this file. This should include at least the VOID dataset
# description and the actual data.
# The target works by merging all prerequisites.
data/temp/all.nt: data/temp void.ttl \
	data/bundorgs/bundorgs.ttl data/bundorgs/stats.ttl
	@echo "combining $(filter-out $<,$^) to $@ ..."
	@rdfpipe -o ntriples $(filter-out $<,$^) > $@

install_templates:
	python bin/install_templates.py

clean: clean-temp

clean-temp:
	@echo "deleting temp folder ..."
	@rm -rf data/temp

data/temp:
	@echo "creating temp directory ..."
	@mkdir -p $@


