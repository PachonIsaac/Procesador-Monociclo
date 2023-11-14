import re

with open("ripes.txt", "r") as f:
    texto = f.read()

binarios = re.findall(r'[01]{32}', texto)

# Unimos todos los binarios extraídos en un solo string separado por saltos de línea.
binarios_limpio = '\n'.join(binarios)

with open("modulos\instructionMemory.txt", "w") as f:
    f.write(binarios_limpio)
