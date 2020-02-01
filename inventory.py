import json
with open('inventory.json') as file_data:
    data = json.load(file_data)
    # data = file_data.readlines()

print(data['Reservations'][0])

# print(parsed_json['Tags'])


