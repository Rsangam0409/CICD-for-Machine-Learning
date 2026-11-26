install:
	python -m pip install --upgrade pip
	python -m pip install -r requirements.txt

format:
	python -m black *.py

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md

	cml comment create report.md