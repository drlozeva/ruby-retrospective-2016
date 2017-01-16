require 'rspec'
RSpec.describe 'Version' do
  it 'creates valid version' do
    expect(Version.new('')).to eq ''
    expect(Version.new('1.0.0.0.1')).to eq '1.0.0.0.1'
    expect(Version.new('0')).to eq '0'
    expect(Version.new('8.0')).to eq '8'
    expect(Version.new('0.0.4')).to eq '0.0.4'
    expect(Version.new).to eq ''
  end
  it 'raises an error' do
    back_error = "Invalid version string '1.2.3.'"
    expect { Version.new('1.2.3.') }.to raise_error(ArgumentError, back_error)
    front_error = "Invalid version string '.1'"
    expect { Version.new('.1' ) }.to raise_error(ArgumentError, front_error)
    dots_error = "Invalid version string '0..2'"
    expect { Version.new('0..2') }.to raise_error(ArgumentError, dots_error)
  end
  it "does not skip leading zeros" do
    expect(Version.new('0.0.2.3').components).to eq [0, 0, 2, 3]
  end
  it "skips trailing zeros" do
    expect(Version.new('1.2.3.0').components).to eq [1, 2, 3]
    expect(Version.new('1.2.3.0.0').components).to eq [1, 2, 3]
  end
  it "does not change the object" do
    version = Version.new('3.1.5')
    version.components.sort!
    expect(version.components).to eq [3, 1, 5]
  end
  it 'implements <' do
    expect(Version.new('1.2.3') < Version.new('1.3.1')).to eq true
    expect(Version.new('1.2.3') < Version.new('1.3')).to eq true
    expect(Version.new('1.4.3') < Version.new('1.3')).to eq false
  end
  it 'implements >' do
    expect(Version.new('1.1') > Version.new('1.0')).to eq true
    expect(Version.new('2.2') > Version.new('2.1.2')).to eq true
    expect(Version.new('2.2') > Version.new('2.3.2')).to eq false
  end
  it 'implements ==' do
    expect(Version.new('1.1.0') == Version.new('1.1')).to eq true
    expect(Version.new('0.1') == Version.new('1')).to eq false
    expect(Version.new('0.2.0') == Version.new('0.2')).to eq true
  end
  it 'implements <=' do
    expect(Version.new('1.0.1') <= Version.new('1.1.1')).to eq true
    expect(Version.new('1.2.1') <= Version.new('1.2.2')).to eq true
    expect(Version.new('1.3.1') <= Version.new('1.2.2')).to eq false
  end
  it 'implements >=' do
    expect(Version.new('4.3.1') >= Version.new('4.3')).to eq true
    expect(Version.new('2.1.1') >= Version.new('2.0.1')).to eq true
    expect(Version.new('2.1.1') >= Version.new('2.6.1')).to eq false
  end
  it 'implements <=>' do
    expect(Version.new('2.2') <=> Version.new('2.2.0.0')).to eq 0
    expect(Version.new('5.6.7') <=> Version.new('1.1.1')).to eq 1
    expect(Version.new('0.0.1') <=> Version.new('3')).to eq -1
    expect(Version.new('0.0.1') > Version.new('0.1.0')).to eq false
  end
  it 'turns version into string' do
    expect(Version.new('1.1.0').to_s).to eq '1.1'
    expect(Version.new('1.0.2').to_s).to eq '1.0.2'
    expect(Version.new('0').to_s).to eq ''
  end
  it 'turns version into components(arrays)' do
    expect(Version.new('1.3.5').components).to eq [1, 3, 5]
    expect(Version.new('1.0.1').components).to eq [1, 0, 1]
    expect(Version.new('0.0.1').components).to eq [0, 0, 1]
    expect(Version.new('1.0').components).to eq [1]
    expect(Version.new('2.0.0').components).to eq [2]
    expect(Version.new('1.3.5').components(2)).to eq [1, 3]
    expect(Version.new('2.2.0.0').components(4)).to eq [2, 2, 0, 0]
  end
  it 'checks if version is in range' do
    range = Version::Range.new(Version.new('1'), Version.new('2'))
    expect((range.include? Version.new('1.5'))).to eq true
  end
  it 'checks if a version is lower than the start one' do
    range = Version::Range.new(Version.new('1'), Version.new('2'))
    expect((range.include? Version.new('0.5'))).to eq false
  end

  it 'checks if a version is greater than the start one' do
    range = Version::Range.new(Version.new('1'), Version.new('2'))
    expect((range.include? Version.new('2.5'))).to eq false
  end
  it "initializes with mix of versions and strings" do
    range1 = Version::Range.new(Version.new('2.8'), '2.8.5')
    expect(range1.to_a).to eq ['2.8', '2.8.1', '2.8.2', '2.8.3', '2.8.4']
    range2 = Version::Range.new('3.2', Version.new('3.2.5'))
    expect(range2.to_a).to eq ['3.2', '3.2.1', '3.2.2', '3.2.3', '3.2.4']
  end
  it 'generates range of versions' do
    input = Version::Range.new(Version.new('1.1'), Version.new('1.1.7')).to_a
    result = ["1.1", "1.1.1", "1.1.2", "1.1.3", "1.1.4", "1.1.5", "1.1.6"]
    expect(input).to eq result
  end
end
