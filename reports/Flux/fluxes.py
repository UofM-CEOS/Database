import logging
import fluxer.eddycov as eddycov
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

logging.basicConfig(level=logging.DEBUG)

# # Test reading files with config
# config = eddycov.db_flux.parse_config("flux1_AMD2017.cfg")
# ec_file = config['EC Inputs']['input_files'][0]
# ecdf, ec_flags = (eddycov.db_flux.prepare_period(ec_file,
#                                                  config))

# Perform the corrections
eddycov.main("flux1_AMD2017.cfg")
eddycov.main("flux2_AMD2017.cfg")

# # Check output
# tilts = pd.read_csv("tilts_1440.csv", index_col=0, parse_dates=True)
# # Get a scaled nfiles_ok
# nfiles_scaled = ((tilts["nfiles_ok"] - tilts["nfiles_ok"].min()) /
#                  tilts["nfiles_ok"].ptp())

# fig, axs = plt.subplots(1, 1, sharex=True)
# fig.set_size_inches((10, 9))
# tilts.plot.scatter("nfiles", "theta_sonic", ax=axs)
# tilts.plot.scatter("nfiles", "phi_sonic", ax=axs, c='red')
# tilts.plot.scatter("nfiles", "theta_motion", ax=axs)
# tilts.plot.scatter("nfiles", "phi_motion", ax=axs, c='red')

# fig, axs = plt.subplots(3, 1, sharex=True)
# fig.set_size_inches((11, 9))
# # tilts[["wind_direction"]].dropna().plot(ax=axs[0], legend=False,
# #                                         title="12-hr windows (2016)")
# # cbar = axs[0].scatter(tilts.index, tilts["wind_direction"], c=nfiles_scaled,
# #                       s=30, cmap=plt.cm.coolwarm)
# # axs[0].set_ylabel("Wind direction ($^\circ$)")
# # fig.colorbar(cbar, ax=axs[0], orientation="horizontal", shrink=0.8,
# #              ticks=[0.17, 0.5, 1], aspect=70, pad=0.04)
# tilts[["nfiles_ok"]].dropna().plot(ax=axs[0], legend=False,
#                                    title="12-hr windows (2016)")
# axs[0].set_ylabel("N runs")
# tilts[["phi_motion"]].dropna().plot(ax=axs[1], legend=False)
# tilts[["phi_sonic"]].dropna().plot(ax=axs[1], rot=0, legend=False)
# axs[1].set_ylabel(r"Roll $\phi$")
# tilts[["theta_motion"]].dropna().plot(ax=axs[2], legend=False)
# tilts[["theta_sonic"]].dropna().plot(ax=axs[2], rot=0, legend=False)
# axs[2].set_ylabel(r"Pitch $\theta$")
# axs[2].set_xlabel("")
# leg = axs[2].legend(loc=9, bbox_to_anchor=(0.5, -0.1), frameon=False,
#                     borderaxespad=0, ncol=2)
# leg.get_texts()[0].set_text("motion sensor")
# leg.get_texts()[1].set_text("sonic anemometer")
# fig.savefig("motion_and_sonic_phitheta.png", bbox_inches="tight")
# plt.close()
