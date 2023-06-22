import os

def export_folder_paths(directory, output_file):
    folder_paths = []

    for root, directories, _ in os.walk(directory):
        for folder in directories:
            folder_path = os.path.join(root, folder)
            folder_path=folder_path+'/images/'
            folder_paths.append(folder_path)
        
    with open(output_file, 'w') as file:
        file.write('\n'.join(folder_paths))

    print(f"Folder paths exported to {output_file}.")

# Specify the directory path
directory_path = "E:/FlutterProject2023/GymBro/gymbro/assets/exercisesJson/exercises/"

# Specify the output file path
output_file_path = "output.txt"

# Call the function to export folder paths
export_folder_paths(directory_path, output_file_path)
