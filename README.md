# SnPM BIDS App

BIDS App containing an instance of the [SnPM software](https://github.com/SnPM-toolbox/SnPM-devel).

## Documentation

To build the container, type:

```
$ docker build -t <yourhandle>/spm12 .
```

To launch an instance of the container and analyse some data, type:

```
$ docker run <yourhandle>/spm12 bids_dir output_dir level [--participant_label PARTICIPANT_LABEL [PARTICIPANT_LABEL ...]]
```

## Error Reporting

If you have a specific problem with the SPM BIDS App, please open an [issue](https://github.com/BIDS-Apps/SnPM/issues) on GitHub.

If your issue concerns SPM more generally, please use the [SnPM mailing list](https://groups.google.com/forum/#!forum/snpm-support)

## Acknowledgement

Please refer to:
