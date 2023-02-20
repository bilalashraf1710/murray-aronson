trigger TriggerCommissionAttachment on ContentDocumentLink (after insert) {
    TriggerCommissionAttachmentHelper.addFileLinkToCommissions(trigger.new);
}