import re
import csv
import subprocess
import time

latency = 13
upper_bound = 21
lower_bound = 20
step = 0.1

syn_command = "./01_run_dc_shell && ./08_check"

start_time = time.time()
print(f"--- Running synthesis with cycle times from {lower_bound} to {upper_bound} with step {step} ---")

# Corrected scaling factor to 100
cycle_times = [round(x / 100.0, 2) for x in range(int(lower_bound * 100), int(upper_bound * 100) + 1, int(step * 100))]

results = []

for cycle in cycle_times:

    # Modify the cycle time in syn.tcl
    with open('syn.tcl', 'r', encoding='utf-8') as f:
        lines = f.readlines()
    with open('syn.tcl', 'w', encoding='utf-8') as f:
        for line in lines:
            if line.strip().startswith('set CYCLE'):
                f.write(f'set CYCLE {cycle}\n')
            else:
                f.write(line)

    # Run the synthesis command
    process = subprocess.run(
        syn_command,
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True,  # For Python 3.6 and earlier
        encoding='utf-8',
        errors='replace'  # Replace undecodable bytes
    )

    output = process.stdout + process.stderr

    success = False
    error_msg = ''
    area = None
    cycle_time = cycle

    if '--> V 02_SYN Success !!' in output:
        success = True
    elif '--> X 02_SYN Fail !!' in output:
        success = False
    else:
        success = False
        error_msg = 'Unknown Synthesis Status'

    area_match = re.search(r'Area:\s*([\d\.]+)', output)
    if area_match:
        area = float(area_match.group(1))
    else:
        area = None
        error_msg += ' | Cannot find area'

    cycle_match = re.search(r'Cycle:\s*([\d\.]+)', output)
    if cycle_match:
        cycle_time_output = float(cycle_match.group(1))
        if abs(cycle_time_output - cycle) > 0.01:
            error_msg += f' | Cycle time mismatch: set to {cycle}, output is {cycle_time_output}'
    else:
        error_msg += ' | Cannot find cycle time'

    if area is not None and cycle_time is not None and latency is not None:
        performance = area * cycle_time * latency
    else:
        performance = None

    results.append({
        'Cycle Time': cycle,
        'Area': area,
        'Performance': performance,
        'Latency': latency,
        'Success': 'Yes' if success else 'No',
        'Error': error_msg.strip()
    })

    # Handle encoding errors in the print statement
    try:
        print(f"Cycle Time: {cycle:2.1f}, Area: {area:7.2f}, Performance: {performance:15.2f}, Latency: {latency:6d}, Success: {success}" + (f", Error: {error_msg}" if error_msg else ""))
    except UnicodeEncodeError:
        print(f"Cycle Time: {cycle:2.1f}, Area: {area:7.2f}, Performance: {performance:15.2f}, Latency: {latency:6d}, Success: {success}")

with open('results.csv', 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['Cycle Time', 'Area', 'Performance', 'Latency', 'Success', 'Error']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for result in results:
        writer.writerow(result)

# find the best successful result
best_result = None
for result in results:
    if result['Success'] == 'Yes':
        if best_result is None or result['Performance'] < best_result['Performance']:
            best_result = result

print(f"--- Total time: {time.time() - start_time} seconds ---")
if best_result is not None:
    print(f"Best result: Cycle Time: {best_result['Cycle Time']}, Area: {best_result['Area']}, Performance: {best_result['Performance']}, Latency: {best_result['Latency']}")
print("Results saved to results.csv")