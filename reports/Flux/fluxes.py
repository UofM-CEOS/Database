import fluxer.eddycov as eddycov
import logging

logging.basicConfig(filename="flux.log", level=logging.DEBUG)
# logger = logging.getLogger("flux1")
# eddycov.main("flux1.cfg")
logger = logging.getLogger("flux2")
eddycov.main("flux2.cfg")
