	.globl		_pcm8a_vsyncint_on
	.globl		_pcm8a_vsyncint_off


	.include	doscall.mac
	.include	iocscall.mac


	.offset 0

par1_l	ds.b	2
par1_w	ds.b	1
par1_b	ds.b	1

par2_l	ds.b	2
par2_w	ds.b	1
par2_b	ds.b	1

par3_l	ds.b	2
par3_w	ds.b	1
par3_b	ds.b	1

par4_l	ds.b	2
par4_w	ds.b	1
par4_b	ds.b	1


	.text
	.even


*��������������������������������������������������������������������������������������
*
*	�����Fvoid	pcm8a_vsyncint_on() ;
*
*��������������������������������������������������������������������������������������

_pcm8a_vsyncint_on:

A7ID	=	4+4*2			*   �X�^�b�N�� return��A�h���X  [ 4 byte ]
					* + �ޔ����W�X�^�̑S�o�C�g��     [ 4*2 byte ]

	movem.l	d0-d1,-(sp)		* ���W�X�^�ޔ�

	bsr	CHK_PCM8A		* PCM8A �풓����
	tst.l	d0
	beq.b	@f			* d0.l==0 �Ȃ� ��풓�Ȃ̂ŋ����I��

	*-------[ pcm8a ���荞�݃}�X�N���H ]
		move.w	#$01FB,d0	* d0.w = �@�\�R�[�h $01FB�F�l�o�t�E�l�e�o�}�X�N�ݒ�
		moveq.l	#-1,d1		* d1.l = ���i���荞�݃��x���^�}�X�N���擾�j
		trap	#2		* ���荞�݃��x���^�}�X�N���擾
					* d0.l = ���݂̊��荞�݃��x���^�}�X�N�l
		move.l	d0,d1
		bset.l	#6,d1		* d0.l = ���H�������荞�݃��x���^�}�X�N�l
		move.w	#$01FB,d0	* d0.w = �@�\�R�[�h $01FB�F�l�o�t�E�l�e�o�}�X�N�ݒ�
		trap	#2		* ���荞�݃��x���^�}�X�N���ݒ�

@@:
	movem.l	(sp)+,d0-d1		* ���W�X�^����
	rts




*��������������������������������������������������������������������������������������
*
*	�����Fvoid	pcm8a_vsyncint_off() ;
*
*��������������������������������������������������������������������������������������

_pcm8a_vsyncint_off:

A7ID	=	4+4*2			*   �X�^�b�N�� return��A�h���X  [ 4 byte ]
					* + �ޔ����W�X�^�̑S�o�C�g��     [ 4*2 byte ]

	movem.l	d0-d1,-(sp)		* ���W�X�^�ޔ�

	bsr	CHK_PCM8A		* PCM8A �풓����
	tst.l	d0
	beq.b	@f			* d0.l==0 �Ȃ� ��풓�Ȃ̂ŋ����I��

	*-------[ pcm8a ���荞�݃}�X�N���H ]
		move.w	#$01FB,d0	* d0.w = �@�\�R�[�h $01FB�F�l�o�t�E�l�e�o�}�X�N�ݒ�
		moveq.l	#-1,d1		* d1.l = ���i���荞�݃��x���^�}�X�N���擾�j
		trap	#2		* ���荞�݃��x���^�}�X�N���擾
					* d0.l = ���݂̊��荞�݃��x���^�}�X�N�l
		move.l	d0,d1
		bclr.l	#6,d1		* d0.l = ���H�������荞�݃��x���^�}�X�N�l
		move.w	#$01FB,d0	* d0.w = �@�\�R�[�h $01FB�F�l�o�t�E�l�e�o�}�X�N�ݒ�
		trap	#2		* ���荞�݃��x���^�}�X�N���ݒ�

@@:
	movem.l	(sp)+,d0-d1		* ���W�X�^����
	rts




*��������������������������������������������������������������������������������������
*
*	�o�b�l�W���@�풓����T�u���[�`��
*
*	CHK_PCM8A
*
*--------------------------------------------------------------------------------------
*
*	�@�\�F	PCM8A�̏풓��������܂��B���[�U�[���[�h����ł����s�ł��܂��B
*
*	�j��F	����
*
*	�ߒl�F	d0.l =  PCM8A �̃o�[�W����*100�i10�i�j
*			��풓�Ȃ�O
*
*��������������������������������������������������������������������������������������

CHK_PCM8A:

	movem.l	d1/a0-a1,-(sp)		* ���W�X�^�ޔ�


*-------[ �X�[�p�[�o�C�U�[���[�h�� ]
	suba.l	a1,a1
	iocs	_B_SUPER		* �X�[�p�[�o�C�U�[���[�h��
	move.l	d0,-(sp)		*�i���Ƃ��ƃX�[�p�[�o�C�U�[���[�h�Ȃ� d0.l=-1�j


*-------[ PCM8A �풓���� ]
	moveq.l	#0,d1			* �ߒl�id1.l�j��������

	movea.l	$0088,a0		* a0.l = ��O�x�N�^ $0022
	lea.l	-16(a0),a0		* a0.l = PCM8A�����x���A�h���X
	lea.l	CHK_CODE(pc),a1		* a1.l = �풓���蕶����A�h���X

	moveq.l	#4,d0			* d0.l = dbra�J�E���^�[�����l
@@:	cmpm.b	(a0)+,(a1)+		* �P������r
	bne.b	EXIT_CHK_PCM8A		* �قȂ�Ȃ狭���I��
	dbra.w	d0,@b			* �T������r����܂ŌJ��Ԃ�

	addq.l	#3,a0			* a0.l ���R�������X�L�b�v

	moveq.l	#7,d0			* d0.l = dbra�J�E���^�[�����l
@@:	cmpm.b	(a0)+,(a1)+		* �P������r
	bne.b	EXIT_CHK_PCM8A		* �قȂ�Ȃ狭���I��
	dbra.w	d0,@b			* �W������r����܂ŌJ��Ԃ�

	move.l	#'PCMA',d1		* d1.l = 'PCMA'
	iocs	_ADPCMMOD
	move.l	d0,d1			* d1.l = �o�[�W����*100�i10�i�j


*-------[ ���[�U�[���[�h�� ]
EXIT_CHK_PCM8A:
	move.l	(sp)+,d0
	bmi.b	@F			* �X�[�p�[�o�C�U�[���[�h������s����Ă�����߂��K�v����
		movea.l	d0,a1
		iocs	_B_SUPER	* ���[�U�[���[�h��
@@:
	move.l	d1,d0			* d0.l = �ߒl�i�o�[�W����*100�i10�i�j�B��풓�Ȃ�O�j
	movem.l	(sp)+,d1/a0-a1		* ���W�X�^����
	rts


*-------[ �풓���蕶���� ]
CHK_CODE:
	dc.b	'PCM8A'
	dc.b	'PCM8/048'

	.even


