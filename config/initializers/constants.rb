PERSON_STATUS_COLORS = {
  'n/a' => nil,
  'Pinged, no response' => '#D3D3D3',
  'Discussing an opportunity' => '#FFF2CC',
  'Not interested' => '#ffc966',
  'Not interested, on hold' => '#ffc966',
  'Interested, ping later' => '#ffffa3',
  'Interested, on hold' => '#ffffa3',
  'Initial interview' => '#CC99CC',
  'Technical interview' => '#a58faa',
  'Additional interview' => '#c181c4',
  'Interview with CEO' => '#CD96CD',
  'Test assignment' => '#EE82EE',
  'Rejected, no go' => '#EB5E66',
  'Rejected, on hold' => '#FFAEB9',
  'Hiring context' => '#99cfe0',
  'Waiting for decision' => '#ADD8E6',
  'Hired' => '#7ff27f',
  'Contractor' => '#7fc270',
  'Past employee' => '#ffc3e1',
  'Past contractor' => '#ecc3e1'
}

VACATION_PER_YEAR_SIZE = JSON.parse(ENV['VACATION_PER_YEAR_SIZE_JSON'])
VACATION_MAX_END_OF_YEAR_TRANSFER = ENV['VACATION_MAX_END_OF_YEAR_TRANSFER'].to_i
