import pandas as pd

# Load the main CSV file
file_path = "nominees.csv"  # Replace with your main CSV file path
df = pd.read_csv(file_path)

# Load the list of unique countries
unique_countries_path = "unique_countries.csv"  # Replace with the unique countries file path
unique_countries_df = pd.read_csv(unique_countries_path)
known_nationalities = unique_countries_df['country_of_citizenship'].tolist()

# Function to handle inverted Nationality and Club columns
def swap_inverted_columns(row):
    if row['Nationality'].strip() not in known_nationalities:
        row['Nationality'], row['Club'] = row['Club'], row['Nationality']
    return row

# Apply the function to fix inverted columns
df = df.apply(swap_inverted_columns, axis=1)

# Function to split `Club` into `club_1` and `club_2`
def split_club_column(row):
    clubs = row['Club'].split('/')
    row['Club'] = clubs[-1].strip()
    return row

# Apply the function to split the Club column
df = df.apply(split_club_column, axis=1)


# Save the cleaned data to a new CSV file
output_file_path = "cleaned_file_with_clubs2.csv"
df.to_csv(output_file_path, index=False)

print(f"Cleaned data saved to {output_file_path}")
