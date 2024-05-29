pragma circom 2.1.5;

include "@zk-email/zk-regex-circom/circuits/regex_helpers.circom";

// regex: [^\r\n]+<[a-zA-Z0-9!#$%&'*+-/=?^_`{\|}~\.]+@[a-zA-Z0-9_\.-]+>
template EmailAddrWithNameRegex(msg_bytes) {
	signal input msg[msg_bytes];
	signal output out;

	var num_bytes = msg_bytes+1;
	signal in[num_bytes];
	in[0]<==255;
	for (var i = 0; i < msg_bytes; i++) {
		in[i+1] <== msg[i];
	}

	component eq[86][num_bytes];
	component lt[26][num_bytes];
	component and[52][num_bytes];
	component multi_or[20][num_bytes];
	signal states[num_bytes+1][14];
	component state_changed[num_bytes];

	states[0][0] <== 1;
	for (var i = 1; i < 14; i++) {
		states[0][i] <== 0;
	}

	for (var i = 0; i < num_bytes; i++) {
		state_changed[i] = MultiOR(13);
		lt[0][i] = LessEqThan(8);
		lt[0][i].in[0] <== 194;
		lt[0][i].in[1] <== in[i];
		lt[1][i] = LessEqThan(8);
		lt[1][i].in[0] <== in[i];
		lt[1][i].in[1] <== 223;
		and[0][i] = AND();
		and[0][i].a <== lt[0][i].out;
		and[0][i].b <== lt[1][i].out;
		and[1][i] = AND();
		and[1][i].a <== states[i][0];
		and[1][i].b <== and[0][i].out;
		lt[2][i] = LessEqThan(8);
		lt[2][i].in[0] <== 160;
		lt[2][i].in[1] <== in[i];
		lt[3][i] = LessEqThan(8);
		lt[3][i].in[0] <== in[i];
		lt[3][i].in[1] <== 191;
		and[2][i] = AND();
		and[2][i].a <== lt[2][i].out;
		and[2][i].b <== lt[3][i].out;
		and[3][i] = AND();
		and[3][i].a <== states[i][2];
		and[3][i].b <== and[2][i].out;
		lt[4][i] = LessEqThan(8);
		lt[4][i].in[0] <== 128;
		lt[4][i].in[1] <== in[i];
		lt[5][i] = LessEqThan(8);
		lt[5][i].in[0] <== in[i];
		lt[5][i].in[1] <== 191;
		and[4][i] = AND();
		and[4][i].a <== lt[4][i].out;
		and[4][i].b <== lt[5][i].out;
		and[5][i] = AND();
		and[5][i].a <== states[i][3];
		and[5][i].b <== and[4][i].out;
		lt[6][i] = LessEqThan(8);
		lt[6][i].in[0] <== 128;
		lt[6][i].in[1] <== in[i];
		lt[7][i] = LessEqThan(8);
		lt[7][i].in[0] <== in[i];
		lt[7][i].in[1] <== 159;
		and[6][i] = AND();
		and[6][i].a <== lt[6][i].out;
		and[6][i].b <== lt[7][i].out;
		and[7][i] = AND();
		and[7][i].a <== states[i][4];
		and[7][i].b <== and[6][i].out;
		lt[8][i] = LessEqThan(8);
		lt[8][i].in[0] <== 49;
		lt[8][i].in[1] <== in[i];
		lt[9][i] = LessEqThan(8);
		lt[9][i].in[0] <== in[i];
		lt[9][i].in[1] <== 223;
		and[8][i] = AND();
		and[8][i].a <== lt[8][i].out;
		and[8][i].b <== lt[9][i].out;
		and[9][i] = AND();
		and[9][i].a <== states[i][8];
		and[9][i].b <== and[8][i].out;
		lt[10][i] = LessEqThan(8);
		lt[10][i].in[0] <== 127;
		lt[10][i].in[1] <== in[i];
		lt[11][i] = LessEqThan(8);
		lt[11][i].in[0] <== in[i];
		lt[11][i].in[1] <== 223;
		and[10][i] = AND();
		and[10][i].a <== lt[10][i].out;
		and[10][i].b <== lt[11][i].out;
		eq[0][i] = IsEqual();
		eq[0][i].in[0] <== in[i];
		eq[0][i].in[1] <== 58;
		eq[1][i] = IsEqual();
		eq[1][i].in[0] <== in[i];
		eq[1][i].in[1] <== 59;
		eq[2][i] = IsEqual();
		eq[2][i].in[0] <== in[i];
		eq[2][i].in[1] <== 60;
		eq[3][i] = IsEqual();
		eq[3][i].in[0] <== in[i];
		eq[3][i].in[1] <== 62;
		eq[4][i] = IsEqual();
		eq[4][i].in[0] <== in[i];
		eq[4][i].in[1] <== 64;
		eq[5][i] = IsEqual();
		eq[5][i].in[0] <== in[i];
		eq[5][i].in[1] <== 91;
		eq[6][i] = IsEqual();
		eq[6][i].in[0] <== in[i];
		eq[6][i].in[1] <== 92;
		eq[7][i] = IsEqual();
		eq[7][i].in[0] <== in[i];
		eq[7][i].in[1] <== 93;
		and[11][i] = AND();
		and[11][i].a <== states[i][9];
		multi_or[0][i] = MultiOR(9);
		multi_or[0][i].in[0] <== and[10][i].out;
		multi_or[0][i].in[1] <== eq[0][i].out;
		multi_or[0][i].in[2] <== eq[1][i].out;
		multi_or[0][i].in[3] <== eq[2][i].out;
		multi_or[0][i].in[4] <== eq[3][i].out;
		multi_or[0][i].in[5] <== eq[4][i].out;
		multi_or[0][i].in[6] <== eq[5][i].out;
		multi_or[0][i].in[7] <== eq[6][i].out;
		multi_or[0][i].in[8] <== eq[7][i].out;
		and[11][i].b <== multi_or[0][i].out;
		multi_or[1][i] = MultiOR(6);
		multi_or[1][i].in[0] <== and[1][i].out;
		multi_or[1][i].in[1] <== and[3][i].out;
		multi_or[1][i].in[2] <== and[5][i].out;
		multi_or[1][i].in[3] <== and[7][i].out;
		multi_or[1][i].in[4] <== and[9][i].out;
		multi_or[1][i].in[5] <== and[11][i].out;
		states[i+1][1] <== multi_or[1][i].out;
		state_changed[i].in[0] <== states[i+1][1];
		eq[8][i] = IsEqual();
		eq[8][i].in[0] <== in[i];
		eq[8][i].in[1] <== 224;
		and[12][i] = AND();
		and[12][i].a <== states[i][0];
		and[12][i].b <== eq[8][i].out;
		and[13][i] = AND();
		and[13][i].a <== states[i][8];
		and[13][i].b <== eq[8][i].out;
		and[14][i] = AND();
		and[14][i].a <== states[i][9];
		and[14][i].b <== eq[8][i].out;
		multi_or[2][i] = MultiOR(3);
		multi_or[2][i].in[0] <== and[12][i].out;
		multi_or[2][i].in[1] <== and[13][i].out;
		multi_or[2][i].in[2] <== and[14][i].out;
		states[i+1][2] <== multi_or[2][i].out;
		state_changed[i].in[1] <== states[i+1][2];
		eq[9][i] = IsEqual();
		eq[9][i].in[0] <== in[i];
		eq[9][i].in[1] <== 225;
		eq[10][i] = IsEqual();
		eq[10][i].in[0] <== in[i];
		eq[10][i].in[1] <== 226;
		eq[11][i] = IsEqual();
		eq[11][i].in[0] <== in[i];
		eq[11][i].in[1] <== 227;
		eq[12][i] = IsEqual();
		eq[12][i].in[0] <== in[i];
		eq[12][i].in[1] <== 228;
		eq[13][i] = IsEqual();
		eq[13][i].in[0] <== in[i];
		eq[13][i].in[1] <== 229;
		eq[14][i] = IsEqual();
		eq[14][i].in[0] <== in[i];
		eq[14][i].in[1] <== 230;
		eq[15][i] = IsEqual();
		eq[15][i].in[0] <== in[i];
		eq[15][i].in[1] <== 231;
		eq[16][i] = IsEqual();
		eq[16][i].in[0] <== in[i];
		eq[16][i].in[1] <== 232;
		eq[17][i] = IsEqual();
		eq[17][i].in[0] <== in[i];
		eq[17][i].in[1] <== 233;
		eq[18][i] = IsEqual();
		eq[18][i].in[0] <== in[i];
		eq[18][i].in[1] <== 234;
		eq[19][i] = IsEqual();
		eq[19][i].in[0] <== in[i];
		eq[19][i].in[1] <== 235;
		eq[20][i] = IsEqual();
		eq[20][i].in[0] <== in[i];
		eq[20][i].in[1] <== 236;
		eq[21][i] = IsEqual();
		eq[21][i].in[0] <== in[i];
		eq[21][i].in[1] <== 238;
		eq[22][i] = IsEqual();
		eq[22][i].in[0] <== in[i];
		eq[22][i].in[1] <== 239;
		and[15][i] = AND();
		and[15][i].a <== states[i][0];
		multi_or[3][i] = MultiOR(14);
		multi_or[3][i].in[0] <== eq[9][i].out;
		multi_or[3][i].in[1] <== eq[10][i].out;
		multi_or[3][i].in[2] <== eq[11][i].out;
		multi_or[3][i].in[3] <== eq[12][i].out;
		multi_or[3][i].in[4] <== eq[13][i].out;
		multi_or[3][i].in[5] <== eq[14][i].out;
		multi_or[3][i].in[6] <== eq[15][i].out;
		multi_or[3][i].in[7] <== eq[16][i].out;
		multi_or[3][i].in[8] <== eq[17][i].out;
		multi_or[3][i].in[9] <== eq[18][i].out;
		multi_or[3][i].in[10] <== eq[19][i].out;
		multi_or[3][i].in[11] <== eq[20][i].out;
		multi_or[3][i].in[12] <== eq[21][i].out;
		multi_or[3][i].in[13] <== eq[22][i].out;
		and[15][i].b <== multi_or[3][i].out;
		lt[12][i] = LessEqThan(8);
		lt[12][i].in[0] <== 144;
		lt[12][i].in[1] <== in[i];
		lt[13][i] = LessEqThan(8);
		lt[13][i].in[0] <== in[i];
		lt[13][i].in[1] <== 191;
		and[16][i] = AND();
		and[16][i].a <== lt[12][i].out;
		and[16][i].b <== lt[13][i].out;
		and[17][i] = AND();
		and[17][i].a <== states[i][5];
		and[17][i].b <== and[16][i].out;
		and[18][i] = AND();
		and[18][i].a <== states[i][6];
		and[18][i].b <== and[4][i].out;
		eq[23][i] = IsEqual();
		eq[23][i].in[0] <== in[i];
		eq[23][i].in[1] <== 128;
		eq[24][i] = IsEqual();
		eq[24][i].in[0] <== in[i];
		eq[24][i].in[1] <== 129;
		eq[25][i] = IsEqual();
		eq[25][i].in[0] <== in[i];
		eq[25][i].in[1] <== 130;
		eq[26][i] = IsEqual();
		eq[26][i].in[0] <== in[i];
		eq[26][i].in[1] <== 131;
		eq[27][i] = IsEqual();
		eq[27][i].in[0] <== in[i];
		eq[27][i].in[1] <== 132;
		eq[28][i] = IsEqual();
		eq[28][i].in[0] <== in[i];
		eq[28][i].in[1] <== 133;
		eq[29][i] = IsEqual();
		eq[29][i].in[0] <== in[i];
		eq[29][i].in[1] <== 134;
		eq[30][i] = IsEqual();
		eq[30][i].in[0] <== in[i];
		eq[30][i].in[1] <== 135;
		eq[31][i] = IsEqual();
		eq[31][i].in[0] <== in[i];
		eq[31][i].in[1] <== 136;
		eq[32][i] = IsEqual();
		eq[32][i].in[0] <== in[i];
		eq[32][i].in[1] <== 137;
		eq[33][i] = IsEqual();
		eq[33][i].in[0] <== in[i];
		eq[33][i].in[1] <== 138;
		eq[34][i] = IsEqual();
		eq[34][i].in[0] <== in[i];
		eq[34][i].in[1] <== 139;
		eq[35][i] = IsEqual();
		eq[35][i].in[0] <== in[i];
		eq[35][i].in[1] <== 140;
		eq[36][i] = IsEqual();
		eq[36][i].in[0] <== in[i];
		eq[36][i].in[1] <== 141;
		eq[37][i] = IsEqual();
		eq[37][i].in[0] <== in[i];
		eq[37][i].in[1] <== 142;
		eq[38][i] = IsEqual();
		eq[38][i].in[0] <== in[i];
		eq[38][i].in[1] <== 143;
		and[19][i] = AND();
		and[19][i].a <== states[i][7];
		multi_or[4][i] = MultiOR(16);
		multi_or[4][i].in[0] <== eq[23][i].out;
		multi_or[4][i].in[1] <== eq[24][i].out;
		multi_or[4][i].in[2] <== eq[25][i].out;
		multi_or[4][i].in[3] <== eq[26][i].out;
		multi_or[4][i].in[4] <== eq[27][i].out;
		multi_or[4][i].in[5] <== eq[28][i].out;
		multi_or[4][i].in[6] <== eq[29][i].out;
		multi_or[4][i].in[7] <== eq[30][i].out;
		multi_or[4][i].in[8] <== eq[31][i].out;
		multi_or[4][i].in[9] <== eq[32][i].out;
		multi_or[4][i].in[10] <== eq[33][i].out;
		multi_or[4][i].in[11] <== eq[34][i].out;
		multi_or[4][i].in[12] <== eq[35][i].out;
		multi_or[4][i].in[13] <== eq[36][i].out;
		multi_or[4][i].in[14] <== eq[37][i].out;
		multi_or[4][i].in[15] <== eq[38][i].out;
		and[19][i].b <== multi_or[4][i].out;
		and[20][i] = AND();
		and[20][i].a <== states[i][8];
		and[20][i].b <== multi_or[3][i].out;
		and[21][i] = AND();
		and[21][i].a <== states[i][9];
		and[21][i].b <== multi_or[3][i].out;
		multi_or[5][i] = MultiOR(6);
		multi_or[5][i].in[0] <== and[15][i].out;
		multi_or[5][i].in[1] <== and[17][i].out;
		multi_or[5][i].in[2] <== and[18][i].out;
		multi_or[5][i].in[3] <== and[19][i].out;
		multi_or[5][i].in[4] <== and[20][i].out;
		multi_or[5][i].in[5] <== and[21][i].out;
		states[i+1][3] <== multi_or[5][i].out;
		state_changed[i].in[2] <== states[i+1][3];
		eq[39][i] = IsEqual();
		eq[39][i].in[0] <== in[i];
		eq[39][i].in[1] <== 237;
		and[22][i] = AND();
		and[22][i].a <== states[i][0];
		and[22][i].b <== eq[39][i].out;
		and[23][i] = AND();
		and[23][i].a <== states[i][8];
		and[23][i].b <== eq[39][i].out;
		and[24][i] = AND();
		and[24][i].a <== states[i][9];
		and[24][i].b <== eq[39][i].out;
		multi_or[6][i] = MultiOR(3);
		multi_or[6][i].in[0] <== and[22][i].out;
		multi_or[6][i].in[1] <== and[23][i].out;
		multi_or[6][i].in[2] <== and[24][i].out;
		states[i+1][4] <== multi_or[6][i].out;
		state_changed[i].in[3] <== states[i+1][4];
		eq[40][i] = IsEqual();
		eq[40][i].in[0] <== in[i];
		eq[40][i].in[1] <== 240;
		and[25][i] = AND();
		and[25][i].a <== states[i][0];
		and[25][i].b <== eq[40][i].out;
		and[26][i] = AND();
		and[26][i].a <== states[i][8];
		and[26][i].b <== eq[40][i].out;
		and[27][i] = AND();
		and[27][i].a <== states[i][9];
		and[27][i].b <== eq[40][i].out;
		multi_or[7][i] = MultiOR(3);
		multi_or[7][i].in[0] <== and[25][i].out;
		multi_or[7][i].in[1] <== and[26][i].out;
		multi_or[7][i].in[2] <== and[27][i].out;
		states[i+1][5] <== multi_or[7][i].out;
		state_changed[i].in[4] <== states[i+1][5];
		eq[41][i] = IsEqual();
		eq[41][i].in[0] <== in[i];
		eq[41][i].in[1] <== 241;
		eq[42][i] = IsEqual();
		eq[42][i].in[0] <== in[i];
		eq[42][i].in[1] <== 242;
		eq[43][i] = IsEqual();
		eq[43][i].in[0] <== in[i];
		eq[43][i].in[1] <== 243;
		and[28][i] = AND();
		and[28][i].a <== states[i][0];
		multi_or[8][i] = MultiOR(3);
		multi_or[8][i].in[0] <== eq[41][i].out;
		multi_or[8][i].in[1] <== eq[42][i].out;
		multi_or[8][i].in[2] <== eq[43][i].out;
		and[28][i].b <== multi_or[8][i].out;
		and[29][i] = AND();
		and[29][i].a <== states[i][8];
		and[29][i].b <== multi_or[8][i].out;
		and[30][i] = AND();
		and[30][i].a <== states[i][9];
		and[30][i].b <== multi_or[8][i].out;
		multi_or[9][i] = MultiOR(3);
		multi_or[9][i].in[0] <== and[28][i].out;
		multi_or[9][i].in[1] <== and[29][i].out;
		multi_or[9][i].in[2] <== and[30][i].out;
		states[i+1][6] <== multi_or[9][i].out;
		state_changed[i].in[5] <== states[i+1][6];
		eq[44][i] = IsEqual();
		eq[44][i].in[0] <== in[i];
		eq[44][i].in[1] <== 244;
		and[31][i] = AND();
		and[31][i].a <== states[i][0];
		and[31][i].b <== eq[44][i].out;
		and[32][i] = AND();
		and[32][i].a <== states[i][8];
		and[32][i].b <== eq[44][i].out;
		and[33][i] = AND();
		and[33][i].a <== states[i][9];
		and[33][i].b <== eq[44][i].out;
		multi_or[10][i] = MultiOR(3);
		multi_or[10][i].in[0] <== and[31][i].out;
		multi_or[10][i].in[1] <== and[32][i].out;
		multi_or[10][i].in[2] <== and[33][i].out;
		states[i+1][7] <== multi_or[10][i].out;
		state_changed[i].in[6] <== states[i+1][7];
		lt[14][i] = LessEqThan(8);
		lt[14][i].in[0] <== 14;
		lt[14][i].in[1] <== in[i];
		lt[15][i] = LessEqThan(8);
		lt[15][i].in[0] <== in[i];
		lt[15][i].in[1] <== 93;
		and[34][i] = AND();
		and[34][i].a <== lt[14][i].out;
		and[34][i].b <== lt[15][i].out;
		lt[16][i] = LessEqThan(8);
		lt[16][i].in[0] <== 95;
		lt[16][i].in[1] <== in[i];
		lt[17][i] = LessEqThan(8);
		lt[17][i].in[0] <== in[i];
		lt[17][i].in[1] <== 127;
		and[35][i] = AND();
		and[35][i].a <== lt[16][i].out;
		and[35][i].b <== lt[17][i].out;
		eq[45][i] = IsEqual();
		eq[45][i].in[0] <== in[i];
		eq[45][i].in[1] <== 0;
		eq[46][i] = IsEqual();
		eq[46][i].in[0] <== in[i];
		eq[46][i].in[1] <== 1;
		eq[47][i] = IsEqual();
		eq[47][i].in[0] <== in[i];
		eq[47][i].in[1] <== 2;
		eq[48][i] = IsEqual();
		eq[48][i].in[0] <== in[i];
		eq[48][i].in[1] <== 3;
		eq[49][i] = IsEqual();
		eq[49][i].in[0] <== in[i];
		eq[49][i].in[1] <== 4;
		eq[50][i] = IsEqual();
		eq[50][i].in[0] <== in[i];
		eq[50][i].in[1] <== 5;
		eq[51][i] = IsEqual();
		eq[51][i].in[0] <== in[i];
		eq[51][i].in[1] <== 6;
		eq[52][i] = IsEqual();
		eq[52][i].in[0] <== in[i];
		eq[52][i].in[1] <== 7;
		eq[53][i] = IsEqual();
		eq[53][i].in[0] <== in[i];
		eq[53][i].in[1] <== 8;
		eq[54][i] = IsEqual();
		eq[54][i].in[0] <== in[i];
		eq[54][i].in[1] <== 9;
		eq[55][i] = IsEqual();
		eq[55][i].in[0] <== in[i];
		eq[55][i].in[1] <== 11;
		eq[56][i] = IsEqual();
		eq[56][i].in[0] <== in[i];
		eq[56][i].in[1] <== 12;
		eq[57][i] = IsEqual();
		eq[57][i].in[0] <== in[i];
		eq[57][i].in[1] <== 255;
		and[36][i] = AND();
		and[36][i].a <== states[i][0];
		multi_or[11][i] = MultiOR(15);
		multi_or[11][i].in[0] <== and[34][i].out;
		multi_or[11][i].in[1] <== and[35][i].out;
		multi_or[11][i].in[2] <== eq[45][i].out;
		multi_or[11][i].in[3] <== eq[46][i].out;
		multi_or[11][i].in[4] <== eq[47][i].out;
		multi_or[11][i].in[5] <== eq[48][i].out;
		multi_or[11][i].in[6] <== eq[49][i].out;
		multi_or[11][i].in[7] <== eq[50][i].out;
		multi_or[11][i].in[8] <== eq[51][i].out;
		multi_or[11][i].in[9] <== eq[52][i].out;
		multi_or[11][i].in[10] <== eq[53][i].out;
		multi_or[11][i].in[11] <== eq[54][i].out;
		multi_or[11][i].in[12] <== eq[55][i].out;
		multi_or[11][i].in[13] <== eq[56][i].out;
		multi_or[11][i].in[14] <== eq[57][i].out;
		and[36][i].b <== multi_or[11][i].out;
		and[37][i] = AND();
		and[37][i].a <== states[i][1];
		and[37][i].b <== and[4][i].out;
		and[38][i] = AND();
		and[38][i].a <== states[i][8];
		multi_or[12][i] = MultiOR(14);
		multi_or[12][i].in[0] <== and[34][i].out;
		multi_or[12][i].in[1] <== and[35][i].out;
		multi_or[12][i].in[2] <== eq[45][i].out;
		multi_or[12][i].in[3] <== eq[46][i].out;
		multi_or[12][i].in[4] <== eq[47][i].out;
		multi_or[12][i].in[5] <== eq[48][i].out;
		multi_or[12][i].in[6] <== eq[49][i].out;
		multi_or[12][i].in[7] <== eq[50][i].out;
		multi_or[12][i].in[8] <== eq[51][i].out;
		multi_or[12][i].in[9] <== eq[52][i].out;
		multi_or[12][i].in[10] <== eq[53][i].out;
		multi_or[12][i].in[11] <== eq[54][i].out;
		multi_or[12][i].in[12] <== eq[55][i].out;
		multi_or[12][i].in[13] <== eq[56][i].out;
		and[38][i].b <== multi_or[12][i].out;
		lt[18][i] = LessEqThan(8);
		lt[18][i].in[0] <== 14;
		lt[18][i].in[1] <== in[i];
		lt[19][i] = LessEqThan(8);
		lt[19][i].in[0] <== in[i];
		lt[19][i].in[1] <== 32;
		and[39][i] = AND();
		and[39][i].a <== lt[18][i].out;
		and[39][i].b <== lt[19][i].out;
		eq[58][i] = IsEqual();
		eq[58][i].in[0] <== in[i];
		eq[58][i].in[1] <== 34;
		eq[59][i] = IsEqual();
		eq[59][i].in[0] <== in[i];
		eq[59][i].in[1] <== 40;
		eq[60][i] = IsEqual();
		eq[60][i].in[0] <== in[i];
		eq[60][i].in[1] <== 41;
		and[40][i] = AND();
		and[40][i].a <== states[i][9];
		multi_or[13][i] = MultiOR(18);
		multi_or[13][i].in[0] <== and[39][i].out;
		multi_or[13][i].in[1] <== eq[45][i].out;
		multi_or[13][i].in[2] <== eq[46][i].out;
		multi_or[13][i].in[3] <== eq[47][i].out;
		multi_or[13][i].in[4] <== eq[48][i].out;
		multi_or[13][i].in[5] <== eq[49][i].out;
		multi_or[13][i].in[6] <== eq[50][i].out;
		multi_or[13][i].in[7] <== eq[51][i].out;
		multi_or[13][i].in[8] <== eq[52][i].out;
		multi_or[13][i].in[9] <== eq[53][i].out;
		multi_or[13][i].in[10] <== eq[54][i].out;
		multi_or[13][i].in[11] <== eq[55][i].out;
		multi_or[13][i].in[12] <== eq[56][i].out;
		multi_or[13][i].in[13] <== eq[58][i].out;
		multi_or[13][i].in[14] <== eq[59][i].out;
		multi_or[13][i].in[15] <== eq[60][i].out;
		multi_or[13][i].in[16] <== eq[0][i].out;
		multi_or[13][i].in[17] <== eq[1][i].out;
		and[40][i].b <== multi_or[13][i].out;
		multi_or[14][i] = MultiOR(4);
		multi_or[14][i].in[0] <== and[36][i].out;
		multi_or[14][i].in[1] <== and[37][i].out;
		multi_or[14][i].in[2] <== and[38][i].out;
		multi_or[14][i].in[3] <== and[40][i].out;
		states[i+1][8] <== multi_or[14][i].out;
		state_changed[i].in[7] <== states[i+1][8];
		and[41][i] = AND();
		and[41][i].a <== states[i][8];
		and[41][i].b <== eq[2][i].out;
		and[42][i] = AND();
		and[42][i].a <== states[i][9];
		and[42][i].b <== eq[2][i].out;
		multi_or[15][i] = MultiOR(2);
		multi_or[15][i].in[0] <== and[41][i].out;
		multi_or[15][i].in[1] <== and[42][i].out;
		states[i+1][9] <== multi_or[15][i].out;
		state_changed[i].in[8] <== states[i+1][9];
		lt[20][i] = LessEqThan(8);
		lt[20][i].in[0] <== 65;
		lt[20][i].in[1] <== in[i];
		lt[21][i] = LessEqThan(8);
		lt[21][i].in[0] <== in[i];
		lt[21][i].in[1] <== 90;
		and[43][i] = AND();
		and[43][i].a <== lt[20][i].out;
		and[43][i].b <== lt[21][i].out;
		lt[22][i] = LessEqThan(8);
		lt[22][i].in[0] <== 94;
		lt[22][i].in[1] <== in[i];
		lt[23][i] = LessEqThan(8);
		lt[23][i].in[0] <== in[i];
		lt[23][i].in[1] <== 126;
		and[44][i] = AND();
		and[44][i].a <== lt[22][i].out;
		and[44][i].b <== lt[23][i].out;
		eq[61][i] = IsEqual();
		eq[61][i].in[0] <== in[i];
		eq[61][i].in[1] <== 33;
		eq[62][i] = IsEqual();
		eq[62][i].in[0] <== in[i];
		eq[62][i].in[1] <== 35;
		eq[63][i] = IsEqual();
		eq[63][i].in[0] <== in[i];
		eq[63][i].in[1] <== 36;
		eq[64][i] = IsEqual();
		eq[64][i].in[0] <== in[i];
		eq[64][i].in[1] <== 37;
		eq[65][i] = IsEqual();
		eq[65][i].in[0] <== in[i];
		eq[65][i].in[1] <== 38;
		eq[66][i] = IsEqual();
		eq[66][i].in[0] <== in[i];
		eq[66][i].in[1] <== 39;
		eq[67][i] = IsEqual();
		eq[67][i].in[0] <== in[i];
		eq[67][i].in[1] <== 42;
		eq[68][i] = IsEqual();
		eq[68][i].in[0] <== in[i];
		eq[68][i].in[1] <== 43;
		eq[69][i] = IsEqual();
		eq[69][i].in[0] <== in[i];
		eq[69][i].in[1] <== 44;
		eq[70][i] = IsEqual();
		eq[70][i].in[0] <== in[i];
		eq[70][i].in[1] <== 45;
		eq[71][i] = IsEqual();
		eq[71][i].in[0] <== in[i];
		eq[71][i].in[1] <== 46;
		eq[72][i] = IsEqual();
		eq[72][i].in[0] <== in[i];
		eq[72][i].in[1] <== 47;
		eq[73][i] = IsEqual();
		eq[73][i].in[0] <== in[i];
		eq[73][i].in[1] <== 48;
		eq[74][i] = IsEqual();
		eq[74][i].in[0] <== in[i];
		eq[74][i].in[1] <== 49;
		eq[75][i] = IsEqual();
		eq[75][i].in[0] <== in[i];
		eq[75][i].in[1] <== 50;
		eq[76][i] = IsEqual();
		eq[76][i].in[0] <== in[i];
		eq[76][i].in[1] <== 51;
		eq[77][i] = IsEqual();
		eq[77][i].in[0] <== in[i];
		eq[77][i].in[1] <== 52;
		eq[78][i] = IsEqual();
		eq[78][i].in[0] <== in[i];
		eq[78][i].in[1] <== 53;
		eq[79][i] = IsEqual();
		eq[79][i].in[0] <== in[i];
		eq[79][i].in[1] <== 54;
		eq[80][i] = IsEqual();
		eq[80][i].in[0] <== in[i];
		eq[80][i].in[1] <== 55;
		eq[81][i] = IsEqual();
		eq[81][i].in[0] <== in[i];
		eq[81][i].in[1] <== 56;
		eq[82][i] = IsEqual();
		eq[82][i].in[0] <== in[i];
		eq[82][i].in[1] <== 57;
		eq[83][i] = IsEqual();
		eq[83][i].in[0] <== in[i];
		eq[83][i].in[1] <== 61;
		eq[84][i] = IsEqual();
		eq[84][i].in[0] <== in[i];
		eq[84][i].in[1] <== 63;
		and[45][i] = AND();
		and[45][i].a <== states[i][9];
		multi_or[16][i] = MultiOR(26);
		multi_or[16][i].in[0] <== and[43][i].out;
		multi_or[16][i].in[1] <== and[44][i].out;
		multi_or[16][i].in[2] <== eq[61][i].out;
		multi_or[16][i].in[3] <== eq[62][i].out;
		multi_or[16][i].in[4] <== eq[63][i].out;
		multi_or[16][i].in[5] <== eq[64][i].out;
		multi_or[16][i].in[6] <== eq[65][i].out;
		multi_or[16][i].in[7] <== eq[66][i].out;
		multi_or[16][i].in[8] <== eq[67][i].out;
		multi_or[16][i].in[9] <== eq[68][i].out;
		multi_or[16][i].in[10] <== eq[69][i].out;
		multi_or[16][i].in[11] <== eq[70][i].out;
		multi_or[16][i].in[12] <== eq[71][i].out;
		multi_or[16][i].in[13] <== eq[72][i].out;
		multi_or[16][i].in[14] <== eq[73][i].out;
		multi_or[16][i].in[15] <== eq[74][i].out;
		multi_or[16][i].in[16] <== eq[75][i].out;
		multi_or[16][i].in[17] <== eq[76][i].out;
		multi_or[16][i].in[18] <== eq[77][i].out;
		multi_or[16][i].in[19] <== eq[78][i].out;
		multi_or[16][i].in[20] <== eq[79][i].out;
		multi_or[16][i].in[21] <== eq[80][i].out;
		multi_or[16][i].in[22] <== eq[81][i].out;
		multi_or[16][i].in[23] <== eq[82][i].out;
		multi_or[16][i].in[24] <== eq[83][i].out;
		multi_or[16][i].in[25] <== eq[84][i].out;
		and[45][i].b <== multi_or[16][i].out;
		and[46][i] = AND();
		and[46][i].a <== states[i][10];
		and[46][i].b <== multi_or[16][i].out;
		multi_or[17][i] = MultiOR(2);
		multi_or[17][i].in[0] <== and[45][i].out;
		multi_or[17][i].in[1] <== and[46][i].out;
		states[i+1][10] <== multi_or[17][i].out;
		state_changed[i].in[9] <== states[i+1][10];
		and[47][i] = AND();
		and[47][i].a <== states[i][10];
		and[47][i].b <== eq[4][i].out;
		states[i+1][11] <== and[47][i].out;
		state_changed[i].in[10] <== states[i+1][11];
		lt[24][i] = LessEqThan(8);
		lt[24][i].in[0] <== 97;
		lt[24][i].in[1] <== in[i];
		lt[25][i] = LessEqThan(8);
		lt[25][i].in[0] <== in[i];
		lt[25][i].in[1] <== 122;
		and[48][i] = AND();
		and[48][i].a <== lt[24][i].out;
		and[48][i].b <== lt[25][i].out;
		eq[85][i] = IsEqual();
		eq[85][i].in[0] <== in[i];
		eq[85][i].in[1] <== 95;
		and[49][i] = AND();
		and[49][i].a <== states[i][11];
		multi_or[18][i] = MultiOR(15);
		multi_or[18][i].in[0] <== and[43][i].out;
		multi_or[18][i].in[1] <== and[48][i].out;
		multi_or[18][i].in[2] <== eq[70][i].out;
		multi_or[18][i].in[3] <== eq[71][i].out;
		multi_or[18][i].in[4] <== eq[73][i].out;
		multi_or[18][i].in[5] <== eq[74][i].out;
		multi_or[18][i].in[6] <== eq[75][i].out;
		multi_or[18][i].in[7] <== eq[76][i].out;
		multi_or[18][i].in[8] <== eq[77][i].out;
		multi_or[18][i].in[9] <== eq[78][i].out;
		multi_or[18][i].in[10] <== eq[79][i].out;
		multi_or[18][i].in[11] <== eq[80][i].out;
		multi_or[18][i].in[12] <== eq[81][i].out;
		multi_or[18][i].in[13] <== eq[82][i].out;
		multi_or[18][i].in[14] <== eq[85][i].out;
		and[49][i].b <== multi_or[18][i].out;
		and[50][i] = AND();
		and[50][i].a <== states[i][12];
		and[50][i].b <== multi_or[18][i].out;
		multi_or[19][i] = MultiOR(2);
		multi_or[19][i].in[0] <== and[49][i].out;
		multi_or[19][i].in[1] <== and[50][i].out;
		states[i+1][12] <== multi_or[19][i].out;
		state_changed[i].in[11] <== states[i+1][12];
		and[51][i] = AND();
		and[51][i].a <== states[i][12];
		and[51][i].b <== eq[3][i].out;
		states[i+1][13] <== and[51][i].out;
		state_changed[i].in[12] <== states[i+1][13];
		states[i+1][0] <== 1 - state_changed[i].out;
	}

	component final_state_result = MultiOR(num_bytes+1);
	for (var i = 0; i <= num_bytes; i++) {
		final_state_result.in[i] <== states[i][13];
	}
	out <== final_state_result.out;
	signal is_consecutive[msg_bytes+1][2];
	is_consecutive[msg_bytes][1] <== 1;
	for (var i = 0; i < msg_bytes; i++) {
		is_consecutive[msg_bytes-1-i][0] <== states[num_bytes-i][13] * (1 - is_consecutive[msg_bytes-i][1]) + is_consecutive[msg_bytes-i][1];
		is_consecutive[msg_bytes-1-i][1] <== state_changed[msg_bytes-i].out * is_consecutive[msg_bytes-1-i][0];
	}
	// substrings calculated: [{(9, 10), (10, 10), (10, 11), (11, 12), (12, 12)}]
	signal is_substr0[msg_bytes][6];
	signal is_reveal0[msg_bytes];
	signal output reveal0[msg_bytes];
	for (var i = 0; i < msg_bytes; i++) {
		is_substr0[i][0] <== 0;
		 // the 0-th substring transitions: [(9, 10), (10, 10), (10, 11), (11, 12), (12, 12)]
		is_substr0[i][1] <== is_substr0[i][0] + states[i+1][9] * states[i+2][10];
		is_substr0[i][2] <== is_substr0[i][1] + states[i+1][10] * states[i+2][10];
		is_substr0[i][3] <== is_substr0[i][2] + states[i+1][10] * states[i+2][11];
		is_substr0[i][4] <== is_substr0[i][3] + states[i+1][11] * states[i+2][12];
		is_substr0[i][5] <== is_substr0[i][4] + states[i+1][12] * states[i+2][12];
		is_reveal0[i] <== is_substr0[i][5] * is_consecutive[i][1];
		reveal0[i] <== in[i+1] * is_reveal0[i];
	}
}